require_relative 'snapshot'
require 'sinatra'
require 'sinatra/jsonp'
require 'yajl'

set :root, File.expand_path('..', File.dirname(__FILE__))

helpers do
  def redirect_to_api
    if request.host =~ /^f/
      redirect request.url.sub %r(://f), '://api.f'
    end
  end

  # Ugly as fuck.
  def snapshot
    symbols = params.delete('symbols') || params.delete('currencies')

    quote = Snapshot
      .new(params)
      .quote

    if symbols
      symbols = symbols.split ','
      quote[:rates].keep_if { |k, v| symbols.include? k }
    end

    quote
  end
end

get '/' do
  File.read File.join 'public', 'index.html'
end

get '/latest' do
  redirect_to_api if production?
  jsonp snapshot
end

get '/:date' do
  redirect_to_api if production?
  jsonp snapshot
end

error do
  "Something is rotten in the state of Denmark."
end
