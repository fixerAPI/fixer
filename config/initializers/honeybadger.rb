require 'honeybadger'

Honeybadger.configure do |config|
  config.environment_name = App.env
  config.api_key = ENV['HONEYBADGER_API_KEY']
end
