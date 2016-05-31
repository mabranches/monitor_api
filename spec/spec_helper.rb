RSpec.configure do |config|
  config.before(:each) do
      $dynamodb.delete_table(table_name:'instances') rescue nil
      $dynamodb.delete_table(table_name:'processes') rescue nil
      $dynamodb.create_table(
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
      ) rescue nil
      $dynamodb.create_table(
        table_name: "processes",
        key_schema:[
          {attribute_name:'instance_id', key_type: 'HASH'},
        ],
        attribute_definitions:[
          {attribute_name:'instance_id', attribute_type: 'S'},
        ],
        provisioned_throughput: { read_capacity_units: 1, write_capacity_units: 1,}
      ) rescue nil
  end
  config.after(:each) do
  end
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
