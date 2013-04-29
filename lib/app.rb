require_relative 'snapshot'
require 'sinatra'
require 'sinatra/jsonp'
require 'yajl'

set :root, File.expand_path('..', File.dirname(__FILE__))

helpers do
  # Ugly as fuck.
  def snapshot
    quotes = Snapshot
      .new(params)
      .quote

    if symbols = params.delete('symbols') || params.delete('currencies')
      symbols = symbols.split ','
      quotes[:rates].keep_if { |k, _| symbols.include? k }
    end

    quotes
  end
end

get '/' do
  redirect 'http://fixer.io'
end

get '/latest' do
  jsonp snapshot
end

get '/:date' do
  jsonp snapshot
end
