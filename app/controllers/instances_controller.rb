class InstancesController < ApplicationController
  before_action :set_instance, only: [:show, :update, :destroy]

  def usage
    items = Usage.get((Time.now - 24.hours).utc.iso8601, Time.now.utc.iso8601)

    result = {}
    items.each do |item|
      add_item_hash(result, item)
    end
    render json: result
  end

  def usage_instance
    items = Usage.get_instance(params[:id], (Time.now - 24.hours).utc.iso8601, Time.now.utc.iso8601)

    result = {}
    items.each do |item|
      add_item_hash(result, item)
    end
    render json: result
  end

  def processes_instance
    items = ProcessList.get_instance(params[:id])
    process_items = {}
    items.each do |item|
      process_items[item['instance_id']] = item
    end
    render json: process_items
  end

  def create
    usage = build_usage_hash params
    process = build_process_hash params

    Usage.create(usage)
    ProcessList.create(process)

    render json: [usage, process], status: :created
  rescue => e
    logger.error("Was not possible to update instance data: #{e.message}")
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def processes
    items = ProcessList.get
    process_items = {}
    items.each do |item|
      process_items[item['instance_id']] = item
    end
    render json: process_items
  end

  def stop
    instance_id = params[:id]

    return render json: {}, status: :unprocessable_entity unless instance_id
    ec2 = Aws::EC2::Resource.new(region: 'us-west-2')
    status = 'stopped'
    begin
      ec2.instance(instance_id).stop
    rescue
      status = 'unknown'
    end
    render json: { instance: instance_id, status: status }
  end

  def start
    instance_id = params[:id]
    return render json: {}, status: :unprocessable_entity unless instance_id
    ec2 = Aws::EC2::Resource.new(region: 'us-west-2')
    status = 'running'
    begin
      ec2.instance(instance_id).start
    rescue
      status = 'unknown'
    end
    render json: { instance: instance_id, status: status }
  end

  def status
    instance_id = params[:id]
    return render json: {}, status: :unprocessable_entity unless instance_id
    begin
      ec2 = Aws::EC2::Resource.new(region: 'us-west-2')
      status = ec2.instance(instance_id).state.name
    rescue => e
      Rails.logger.error("Impossible to get instance status:#{e.message}")
      status = 'unknown'
    end
    render json: { instance_id: instance_id, status: status }
  end

  private

  def add_item_hash(result, item)
    result[item['instance_id']] ||= Hash.new { |h, k| h[k] = [] }
    result[item['instance_id']]['mem'] << item['mem']
    result[item['instance_id']]['disk'] << item['disk']
    result[item['instance_id']]['cpu'] << item['cpu']
    result[item['instance_id']]['usage_time'] << item['usage_time']
  end

  def build_usage_hash(params)
    instance = params[:instance]
    {
      instance_id: params[:id],
      cpu: instance[:cpu],
      mem: instance[:mem],
      disk: instance[:disk],
      usage_time: Time.now.utc.iso8601
    }
  end

  def build_process_hash(params)
    instance = params[:instance]
    {
      instance_id: params[:id],
      process: instance[:process].try(:values) || []
    }
  end
end
