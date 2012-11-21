require_relative 'snapshot'
require 'sinatra'
require 'sinatra/jsonp'
require 'yajl'

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
    .with_base(base)
    .to_hash
end

get '/:date' do |date|
  jsonp Snapshot
    .new(date)
    .with_base(base)
    .to_hash
end
