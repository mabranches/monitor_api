module Model
  def table_name(table_name)
    @@table_name = table_name
  end
  def count
    $dynamodb.scan(table_name: @@table_name).count
  end
end
