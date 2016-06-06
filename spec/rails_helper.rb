# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'

class DynSpecData
  def self.create_usage_data(usage_data=[])
    create_dynamo_db_data(Usage, usage_data)
  end

  def self.create_process_data(process_data=[])
    create_dynamo_db_data(ProcessList, process_data)
  end
private
  def self.create_dynamo_db_data(klass, data)
    data.each do |datum|
      klass.create(datum)
    end
  end
end

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
