require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

RSpec.configure do |config|
  config.before(:each) do
    Usage.delete_table rescue nil
    ProcessList.delete_table rescue nil
    Usage.create_table rescue nil
    ProcessList.create_table rescue nil
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
