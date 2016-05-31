module Model
  def table_name(table_name)
    @@table_name = table_name
  end
  def count
    $dynamodb.scan(table_name: @@table_name).count
  end
  def create(item)
    $dynamodb.put_item(table_name:@@table_name, item: usage)
  end
  def delete_table
    $dynamodb.delete_table(table_name:@@table_name) rescue nil
  end
end
