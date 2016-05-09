# frozen_string_literal: true

require 'oj'
require 'sinatra'
require 'rack/cors'
require 'quote'

configure :development do
  set :show_exceptions, :after_handler
end

configure :production do
  require 'newrelic_rpm'
end

helpers do
  def quote
    @quote ||= Quote.new(params).attributes.tap do |data|
      data[:rates].keep_if { |k, _| symbols.include?(k) } if symbols
    end
  rescue Quote::Invalid => ex
    halt 422, encode_json(error: ex.message)
  end

  def symbols
    @symbols ||= params.values_at('symbols', 'currencies').first
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

use Rack::Cors do
  allow do
    origins '*'
    resource '*'
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
  last_modified quote[:date]
  jsonp quote
end

get(/(?<date>\d{4}-\d{2}-\d{2})/) do
  last_modified quote[:date]
  jsonp quote
end

not_found do
  halt 404, encode_json(error: 'Not found')
end
