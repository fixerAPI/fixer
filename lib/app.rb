require_relative 'snapshot'
require 'sinatra'
require 'sinatra/jsonp'

get '/' do
  File.read File.join 'public', 'index.html'
end

get '/latest' do
  jsonp Snapshot.last
end

get '/historical/:date' do
  jsonp Snapshot.new params[:date]
end
