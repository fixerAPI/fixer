# frozen_string_literal: true

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
end

get '/' do
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
  halt_with_message 404, 'Not found'
end
