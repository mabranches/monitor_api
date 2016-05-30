namespace :db do
  desc 'Create Table processes at DynamoDB'
  task :create_processes => :environment do

    $dynamodb.create_table(
      table_name: "processes",
      key_schema:[
        {attribute_name:'instance_id', key_type: 'HASH'},
      ],
      attribute_definitions:[
        {attribute_name:'instance_id', attribute_type: 'S'},
      ],
      provisioned_throughput: { read_capacity_units: 1, write_capacity_units: 1,}
    )
  end
end
