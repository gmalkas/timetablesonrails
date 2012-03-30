require 'active_record'
require 'rspec/rails/extensions/active_record/base'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

schema_path = File.expand_path('../db/schema.rb', File.dirname(__FILE__))
load schema_path

RSpec.configure do |config|
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
