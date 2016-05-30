class InstancesController < ApplicationController
  before_action :set_instance, only: [:show, :update, :destroy]

  # GET /instances
  # GET /instances.json
  def usage
    items = $dynamodb.scan(
      table_name:'instances',
      filter_expression: "usage_time < :now and usage_time > :24h_before",
      expression_attribute_values:{
        ":now": Time.now.utc.iso8601,
        ":24h_before":(Time.now - 24.hour).utc.iso8601
      }).data.items

    result = {}
    items.each do |item|
      #initialize
      result[item["instance_id"]] ||= {}
      result[item["instance_id"]]["mem"] ||= []
      result[item["instance_id"]]["disk"] ||= []
      result[item["instance_id"]]["cpu"] ||= []
      result[item["instance_id"]]["usage_time"] ||= []
      #add_item
      result[item["instance_id"]]["mem"] << item["mem"]
      result[item["instance_id"]]["disk"] << item["disk"]
      result[item["instance_id"]]["cpu"] << item["cpu"]
      result[item["instance_id"]]["usage_time"] << item["usage_time"]
    end

    render json: result
  end

  # POST /instances
  # POST /instances.json
  def create
    #create connection at a initializer
    time = Time.now.utc.iso8601
    usage = {
      instance_id: params[:instance_id],
      cpu: params[:cpu],
      mem: params[:mem],
      disk: params[:disk],
      usage_time: time
    }

    process = {
      instance_id: params[:instance_id],
      process: (params[:process].values rescue [])
    }

    $dynamodb.put_item(table_name:'instances', item: usage)
    $dynamodb.put_item(table_name:'processes', item: process)

    render json: [usage, process], status: :created
    rescue Exception => e
      puts e.message
      render json: {error:e.message}, status: :unprocessable_entity
  end

  def processes
    items = $dynamodb.scan(
      table_name:'processes'
      ).data.items

    process_items = items.collect do |item|
      {item["instance_id"] => item}
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
    render json: {instance:instance_id, status: 'stopped'}
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
    render json: {instance:instance_id, status: status}
  end

  def status
    instance_id = params[:id]
    return render json: {}, status: :unprocessable_entity unless instance_id
    ec2 = Aws::EC2::Resource.new(region: 'us-west-2')
    status = ec2.instance(instance_id).state.name rescue "unknown"
    render json: {instance_id: instance_id, status: status}
  end
end
