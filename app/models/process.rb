class Process
  extend Model
  table_name 'processes'
  def self.get
    items = $dynamodb.scan(
      table_name:'processes'
    ).data.items
  end

  def self.create_table
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
end
