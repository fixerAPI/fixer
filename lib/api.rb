# frozen_string_literal: true

require 'sinatra'
require 'sinatra/jsonp'
require 'yajl'
require 'quote'

configure do
  set :options_response_headers,
      'Allow'                            => 'HEAD, GET, OPTIONS',
      'Access-Control-Allow-Headers'     => 'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'

  set :cors_response_headers,
      'Access-Control-Allow-Credentials' => 'true',
      'Access-Control-Allow-Headers'     => '*, Content-Type, Accept, AUTHORIZATION, Cache-Control',
      'Access-Control-Allow-Methods'     => 'POST, GET, OPTIONS',
      'Access-Control-Allow-Origin'      => '*',
      'Access-Control-Expose-Headers'    => 'Cache-Control, Content-Language, Content-Type, Expires, Last-Modified, Pragma',
      'Access-Control-Max-Age'           => '1728000'
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
      ret = Quote.new(params).attributes
      ret[:rates].keep_if { |k, _| symbols.include?(k) } if symbols

      ret
    end
  rescue Quote::Invalid => ex
    halt_with_message 422, ex.message
  end

  def symbols
    return @symbols if defined?(@symbols)

    @symbols = begin
      ret = params.delete('symbols') || params.delete('currencies')
      ret.split(',') if ret
    end
  end

  def halt_with_message(status, message)
    halt status, Yajl::Encoder.encode(error: message)
  end

  def enable_cross_origin
    headers settings.cors_response_headers
  end
end

# https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS#Preflighted_requests
options '*' do
  headers settings.options_response_headers
  pass
end

get '/' do
  enable_cross_origin
  jsonp details: 'http://fixer.io', version: App.version
end

get '/latest' do
  enable_cross_origin
  last_modified quote[:date]
  jsonp quote
end

get(/(?<date>\d{4}-\d{2}-\d{2})/) do
  enable_cross_origin
  last_modified quote[:date]
  jsonp quote
end

not_found do
  halt_with_message 404, 'Not found'
end
