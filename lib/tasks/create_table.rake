namespace :db do
  desc 'Create Table Instances at DynamoDB'
  task :create_instances do

    dynamodb = Aws::DynamoDB::Client.new(region: 'us-west-2')
    dynamodb.create_table(
      table_name: "instances",
      key_schema:[
        {attribute_name:'instance_id', key_type: 'HASH'},
        {attribute_name: 'usage_time', key_type: 'RANGE'}
      ],
      attribute_definitions:[
        {attribute_name:'instance_id', attribute_type: 'S'},
        {attribute_name:'usage_time', attribute_type: 'S'}
      ],
      provisioned_throughput: { read_capacity_units: 1, write_capacity_units: 1,}
    )
  end
end
