require './lib/dynamodb.rb'
module Model
  extend ActiveSupport::Concern

  module ClassMethods
    def count
      conn.scan(table_name: @table_name).count
    end

    def create(item)
      conn.put_item(table_name: @table_name, item: item)
    end

    def delete_table
      conn.delete_table(table_name: @table_name)
    end

    def conn
      @conn ||= Dynamodb.instance.conn
    end
  end
  included do
    attr_accessor :table_name, :conn
  end
end
