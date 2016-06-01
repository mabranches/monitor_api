module Model
  extend ActiveSupport::Concern

  module ClassMethods
    def table_name=(table_name)
      @table_name = table_name
    end
    def table_name
      @table_name
    end
    def count
      $dynamodb.scan(table_name: @table_name).count
    end
    def create(item)
      $dynamodb.put_item(table_name: @table_name, item: item)
    end
    def delete_table
      $dynamodb.delete_table(table_name: @table_name)
    end
  end
end
