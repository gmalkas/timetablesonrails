ENV["RAILS_ENV"] ||= 'test'

require 'factory_girl_rails'
require 'active_record'
require 'logger'
require 'rspec/rails/extensions/active_record/base'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
ActiveRecord::Base.logger = Logger.new('/dev/null')

schema_path = File.expand_path('../db/schema.rb', File.dirname(__FILE__))
load schema_path

RSpec.configure do |config|
  
  # Use transactions
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end

end

# Load factories
FactoryGirl.find_definitions
