require './lib/dynamodb.rb'
module Model
  extend ActiveSupport::Concern

  module ClassMethods
    def table_name=(table_name)
      @table_name = table_name
    end
    def table_name
      @table_name
    end
    def conn=(conn)
      @conn = conn
    end
    def conn
      @conn
    end
    def count
      @conn.scan(table_name: @table_name).count
    end
    def create(item)
      @conn.put_item(table_name: @table_name, item: item)
    end
    def delete_table
      @conn.delete_table(table_name: @table_name)
    end
  end
  included do
    self.conn = Dynamodb.instance.conn
  end
end
