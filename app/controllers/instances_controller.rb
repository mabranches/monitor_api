class InstancesController < ApplicationController
  before_action :set_instance, only: [:show, :update, :destroy]

  # GET /instances
  # GET /instances.json
  def usage
    dynamodb = Aws::DynamoDB::Client.new(region: 'us-west-2')
    items = dynamodb.scan(
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
    dynamodb = Aws::DynamoDB::Client.new(region: 'us-west-2')
    usage = { 
      instance_id: params[:instance_id],
      cpu: params[:cpu],
      mem: params[:mem],
      disk: params[:disk],
      usage_time: Time.now.utc.iso8601
    }
    
    dynamodb.put_item(table_name:'instances', item: usage)# add entry on DynDB
    #if @instance.save
      render json: usage, status: :created, location: usage 
    #else
    #  render json: @instance.errors, status: :unprocessable_entity
    #end
  end

  def stop
    instance_id = params[:id]
    return render json: {}, status: :unprocessable_entity unless instance_id
    ec2 = Aws::EC2::Resource.new(region: 'us-west-2')
    ec2.instance(instance_id).stop
    render json: {instance:instance_id, status: 'stopped'}
  end

  def start
    instance_id = params[:id]
    return render json: {}, status: :unprocessable_entity unless instance_id
    ec2 = Aws::EC2::Resource.new(region: 'us-west-2')
    ec2.instance(instance_id).start
    render json: {instance:instance_id, status: 'running'}
  end
 
  def status
    instance_id = params[:id]
    return render json: {}, status: :unprocessable_entity unless instance_id
    ec2 = Aws::EC2::Resource.new(region: 'us-west-2')
    status = ec2.instance(instance_id).state.name
    render json: {instance_id: instance_id, status: status}
  end
end
