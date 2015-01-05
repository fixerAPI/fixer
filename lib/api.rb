require 'sinatra'
require 'sinatra/cross_origin'
require 'sinatra/jsonp'
require 'yajl'
require 'snapshot'

configure do
  enable :cross_origin
  set :root, File.expand_path('..', File.dirname(__FILE__))
end

configure :production do
  require 'newrelic_rpm'
  require 'librato-rack'

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
    halt status, Yajl::Encoder.encode(error: { status: status, message: message })
  end
end

get '/' do
  jsonp(description: 'Fixer.io is a JSON API for foreign exchange rates and currency conversion', docs: 'http://fixer.io')
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
