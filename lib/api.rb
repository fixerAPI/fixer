# frozen_string_literal: true
require 'oj'
require 'sinatra'
require 'rack/cors'
require 'quote'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :get
  end
end

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
end

options '*' do
  200
end

get '*' do
  cache_control :public, :must_revalidate, max_age: 900
  pass
end

get '/' do
  etag App.version
  jsonp details: 'http://fixer.io', version: App.version
end

get '/latest' do
  last_modified quote.date
  jsonp quote.to_h
end

get(/(?<date>\d{4}-\d{2}-\d{2})/) do
  last_modified quote.date
  jsonp quote.to_h
end

not_found do
  halt 404, encode_json(error: 'Not found')
end

error Quote::Invalid do |ex|
  halt 422, encode_json(error: ex.message)
end
