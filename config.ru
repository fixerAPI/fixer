require './config/environment'
require 'api'

use Honeybadger::Rack
run Sinatra::Application
