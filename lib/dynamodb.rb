require 'singleton'
class Dynamodb
  include Singleton
  attr_reader :conn
  def initialize
    if Rails.env == 'production'
      return @conn = Aws::DynamoDB::Client.new(region: 'us-west-2')
    end
    @conn = Aws::DynamoDB::Client.new(region: 'us-west-2', endpoint: 'http://localhost:8000')
  end
end
