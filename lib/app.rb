require_relative 'snapshot'
require 'sinatra'
require 'sinatra/jsonp'
require 'yajl'

set :root, File.expand_path('..', File.dirname(__FILE__))

helpers do
  def base
    params[:base] || Snapshot::DEFAULT_BASE
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

get '/:date' do
  jsonp Snapshot
    .new(params[:date])
    .with_base(base)
    .to_hash
end
