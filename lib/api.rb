require 'rollbar/rack'
require 'sinatra'
require 'sinatra/cross_origin'
require 'sinatra/jsonp'
require 'yajl'
require 'snapshot'

configure do
  enable :cross_origin
end

configure :development do
  set :show_exceptions, :after_handler
end

configure :production do
  require 'newrelic_rpm'
end

helpers do
  def snapshot
    quotes = Snapshot.new(params).quote

    symbols = params.delete('symbols') || params.delete('currencies')
    if symbols
      symbols = symbols.split(',')
      quotes[:rates].keep_if { |k, _| symbols.include?(k) }
    end

    quotes
  end

  def process_date
    params[:date] = Date.new(
      params[:year].to_i, params[:month].to_i, params[:day].to_i
    )
  end

  def halt_with_message(status, message)
    halt status, Yajl::Encoder.encode(error: message)
  end
end

get '/' do
  jsonp details: 'http://fixer.io', version: App.version
end

get '/latest' do
  jsonp snapshot
end

get(/(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/) do
  process_date
  jsonp snapshot
end

not_found do
  halt_with_message 404, 'Not found'
end

error ArgumentError do
  halt_with_message 422, env['sinatra.error'].message.capitalize
end
