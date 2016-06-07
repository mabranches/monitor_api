namespace :db do
  desc 'Create Tables at DynamoDB'
  task create_tables: :environment do
    begin
      Usage.create_table
    rescue => e
      Rails.logger.error("Error creating usage table: #{e.message}")
    end
    begin
      ProcessList.create_table
    rescue => e
      Rails.logger.error("Error creating processes table: #{e.message}")
    end
  end
end
