namespace :db do
  desc 'Create Table Instances at DynamoDB'
  task :create_instances => :environment do
    Usage.create_table
  end
end
