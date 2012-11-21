require_relative 'snapshot'
require 'sinatra'
require 'sinatra/jsonp'

helpers do
  def base
    params[:base] || 'EUR'
  end
end

get '/' do
  File.read File.join 'public', 'index.html'
end

get '/latest' do
  jsonp Snapshot
    .last
    .to_base base
end

get '/:date' do |date|
  jsonp Snapshot
    .new(date)
    .to_base base
end
