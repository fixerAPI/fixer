require_relative 'snapshot'
require 'sinatra'
require 'sinatra/jsonp'
require 'yajl'

set :root, File.expand_path('..', File.dirname(__FILE__))

helpers do
  def snapshot
    Snapshot
      .new(params)
      .quote
  end
end

get '/' do
  File.read File.join 'public', 'index.html'
end

get '/latest' do
  jsonp snapshot
end

get '/:date' do
  jsonp snapshot
end

error do
  "Something is rotten in the state of Denmark."
end
