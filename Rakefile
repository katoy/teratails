require 'active_record'
require 'yaml'
require 'erb'
require 'logger'

config = nil
APP_ROOT = '.'

task :default => 'db:migrate'

namespace :db do
  MIGRATIONS_DIR = 'db/migrate'

  desc "Migrate the database"
  task :migrate => :environment do
    ActiveRecord::Migrator.migrate(MIGRATIONS_DIR, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  end

  desc 'Roll back the database schema to the previous version'
  task :rollback => :environment do
    ActiveRecord::Migrator.rollback(MIGRATIONS_DIR, ENV['STEP'] ? ENV['STEP'].to_i : 1)
  end

  desc 'Drop the database'
  task :drop => :environment do
    drop_database(config)
  end

  task :environment do
    dbconfig = YAML.load(ERB.new(File.read('config/database.yml')).result)

    # `rake ENV=development` / `rake ENV=production` で切り替え可能
    env = ENV['ENV'] || 'development'
    config = dbconfig[env]
    ActiveRecord::Base.establish_connection(config)
    # ActiveRecord::Base.logger = Logger.new('log/database.log')
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end
end

def drop_database(config)
  case config['adapter']
  when 'mysql'
    ActiveRecord::Base.establish_connection(config)
    ActiveRecord::Base.connection.drop_database config['database']
  when /^sqlite/
    FileUtils.rm(File.join(APP_ROOT, config['database']))
  when 'postgresql'
    ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
    ActiveRecord::Base.connection.drop_database config['database']
  end
end
