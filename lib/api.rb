# frozen_string_literal: true

require 'oj'
require 'sinatra'
require 'rack/cors'
require 'quote'

set :cache_ttl, 900 # 15 minutes

configure :development do
  set :show_exceptions, :after_handler
end

configure :production do
  require 'newrelic_rpm'
  disable :dump_errors
end

helpers do
  def quote
    @quote ||= Quote.new(params)
  end

  def quote_attributes
    @quote_attributes ||= quote.attributes.tap do |data|
      data[:rates].keep_if { |k, _| symbols.include?(k) } if symbols
    end
  end

  def symbols
    @symbols ||= params.values_at('symbols', 'to').compact.first
  end

  def jsonp(data)
    json = encode_json(data)
    callback = params.delete('callback')
    if callback
      content_type :js
      "#{callback}(#{json})"
    else
      content_type :json
      json
    end
  end

  def encode_json(data)
    Oj.dump(data, mode: :compat)
  end

  def cache
    App.cache.fetch request.fullpath, settings.cache_ttl do
      yield
    end
  end
end

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :get
  end
end

options '*' do
  200
end

get '/' do
  last_modified App.released_at
  jsonp details: 'http://fixer.io', version: App.version
end

get '/latest' do
  cache do
    last_modified quote_attributes[:date]
    jsonp quote_attributes
  end
end

get(/(?<date>\d{4}-\d{2}-\d{2})/) do
  cache do
    last_modified quote_attributes[:date]
    jsonp quote_attributes
  end
end

not_found do
  halt 404, encode_json(error: 'Not found')
end

error Quote::Invalid do |ex|
  halt 422, encode_json(error: ex.message)
end
