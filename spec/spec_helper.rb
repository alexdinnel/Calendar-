require 'bundler/setup'
Bundler.require(:default)

database_configuration = YAML::load(File.open('./db/config.yml'))
test_configuration = database_configuration['test']
ActiveRecord::Base.establish_connection(test_configuration)

RSpec.configure do |config|
  config.after(:each) do
    Event.all { |event| event.destroy }
  end
end
