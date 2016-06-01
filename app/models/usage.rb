class Usage
  extend Model
  table_name 'instances'
  def get(start, stop)
      items = $dynamodb.scan(
      table_name:'instances',
      filter_expression: "usage_time < :now and usage_time > :stop",
      expression_attribute_values:{
        ":now": start,
        ":stop": stop
      }).data.items
  end

  def creat_table
    $dynamodb.create_table(
      table_name: @@table_name,
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
  end
end
