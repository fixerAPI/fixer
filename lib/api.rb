# frozen_string_literal: true

require 'json'
require 'sinatra'
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
      Quote.new(params).attributes.tap do |quote|
        quote[:rates].keep_if { |k, _| symbols.include?(k) } if symbols
      end
    end
  rescue Quote::Invalid => ex
    halt 422, JSON.generate(error: ex.message)
  end

  def symbols
    @symbols ||= params.values_at('symbols', 'currencies').first
  end

  def jsonp(data)
    callback = params.delete('callback')
    if callback
      content_type :js
      "#{callback}(#{JSON.generate(data)})"
    else
      content_type :json
      JSON.generate(data)
    end
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
  last_modified App.released_at
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
  halt 404, JSON.generate(error: 'Not found')
end
