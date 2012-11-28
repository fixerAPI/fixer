require_relative 'helper'
require 'rack/test'
require 'app'

describe 'the application' do
  include Rack::Test::Methods

  let(:app)  { Sinatra::Application }
  let(:json) { Yajl::Parser.new.parse last_response.body }
  let(:status) { last_response.status }

  it 'returns latest snapshot' do
    get '/latest'
    last_response.must_be :ok?
  end

  it 'sets base currency' do
    get '/latest?base=USD'
    json['base'].must_equal 'USD'
  end

  it 'filters symbols' do
    get '/latest?symbols=USD'
    json['rates'].keys.must_equal %w(USD)
  end

  it 'returns historical data' do
    get '/2012-11-20'
    json['rates'].wont_be :empty?
  end

  it 'works around holidays' do
    get '/2010-01-01'
    json['rates'].wont_be :empty?
  end
end
