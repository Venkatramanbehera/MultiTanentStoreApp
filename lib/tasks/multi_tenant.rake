namespace :tenants do
  desc "Run migrations for all tenants"

  task migrate: :environment do
    puts "== Migrating Public Schema =="
    ActiveRecord::Base.connection.schema_search_path = "public"
    ActiveRecord::Tasks::DatabaseTasks.migrate
    puts "== Public Schema Complete ==\n"

    # 2. Iterate through all clients
    Client.find_each do |client|
      puts "== Migrating Tenant: #{client.subdomain} =="

      begin
        # Switch to the tenant schema
        ActiveRecord::Base.connection.schema_search_path = "#{client.subdomain}, public"

        # Run the migrations using Rails internal tools
        ActiveRecord::Tasks::DatabaseTasks.migrate

        puts "   -> Success"
      rescue StandardError => e
        puts "   -> FAILED: #{e.message}"
      end
    end

    ActiveRecord::Base.connection.schema_search_path = "public"
    puts "\n== All Tenants Updated =="
  end
end
