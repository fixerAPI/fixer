require 'sinatra'
require 'sinatra/jsonp'
require 'yajl'
require 'snapshot'

set :root, File.expand_path('..', File.dirname(__FILE__))

configure :production do
  require 'newrelic_rpm'
  require 'librato-rack'

  use Honeybadger::Rack
  use Librato::Rack
end

helpers do
  def snapshot
    quotes = Snapshot.new(params).quote

    if symbols = params.delete('symbols') || params.delete('currencies')
      symbols = symbols.split(',')
      quotes[:rates].keep_if { |k, _| symbols.include?(k) }
    end

    quotes
  end

  def process_date
    params[:date] = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
  end

  def halt_with_meaningful_response(status, message)
    halt status, message
  end
end

get '/' do
  jsonp(name: 'Fixer', description: 'JSON API for foreign exchange rates and currency conversion', docs: 'http://fixer.io')
end

get '/latest' do
  jsonp snapshot
end

get %r((?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})) do
  process_date
  jsonp snapshot
end

not_found do
  halt_with_meaningful_response 404, 'Not found'
end

error ArgumentError do
  halt_with_meaningful_response 422, env['sinatra.error'].message.capitalize
end
