namespace :db do
  desc 'Create Table processes at DynamoDB'
  task :create_processes => :environment do
    Process.create_table
  end
end
