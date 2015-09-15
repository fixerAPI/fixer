require 'sinatra'
require 'sinatra/cross_origin'
require 'sinatra/jsonp'
require 'yajl'
require 'quote'

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
  def quote
    @quote ||= begin
      ret = Quote.new(params).to_h
      ret[:rates].keep_if { |k, _| symbols.include?(k) } if symbols

      ret
    end
  end

  def symbols
    return @symbols if defined?(@symbols)

    @symbols = begin
      ret = params.delete('symbols') || params.delete('currencies')
      ret.split(',') if ret
    end
  end

  def transform_date
    params[:date] = Date.new(
      params.delete('year').to_i,
      params.delete('month').to_i,
      params.delete('day').to_i
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
  jsonp quote
end

get(/(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/) do
  transform_date
  jsonp quote
end

not_found do
  halt_with_message 404, 'Not found'
end

error ArgumentError do
  halt_with_message 422, env['sinatra.error'].message.capitalize
end
