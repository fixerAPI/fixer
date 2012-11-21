require_relative 'helper'
require 'rack/test'
require 'app'

describe 'the application' do
  include Rack::Test::Methods

  let(:app)  { Sinatra::Application }
  let(:json) { Yajl::Parser.new.parse last_response.body }

  it 'returns latest snapshot' do
    get '/latest'
    assert last_response.ok?
  end

  it 'sets base currency' do
    get '/latest?base=USD'
    json['base'].must_equal 'USD'
  end

  it 'filters symbols' do
    skip 'enterprise feature'
    get '/latest?symbols=USD'
    json['rates'].keys.must_equal %w(USD)
  end
end
