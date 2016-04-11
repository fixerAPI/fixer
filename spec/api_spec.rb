# frozen_string_literal: true

require_relative 'helper'
require 'rack/test'
require 'api'

describe 'the API' do
  include Rack::Test::Methods

  let(:app)  { Sinatra::Application }
  let(:json) { Yajl::Parser.new.parse last_response.body }
  let(:headers) { last_response.headers }

  it 'describes itself' do
    get '/'
    last_response.must_be :ok?
  end

  it 'returns latest quotes' do
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

  it 'returns historical quotes' do
    get '/2012-11-20'
    json['rates'].wont_be :empty?
    json['date'].must_equal '2012-11-20'
  end

  it 'works around holidays' do
    get '/2010-01-01'
    json['rates'].wont_be :empty?
  end

  it 'returns a last modified header for latest quote' do
    get '/latest'
    headers['Last-Modified'].wont_be_nil
  end

  it 'returns a last modified header for historical quote' do
    get '/2012-11-20'
    headers['Last-Modified'].wont_be_nil
  end

  it 'allows cross-origin requests' do
    get '/', {}, 'HTTP_ORIGIN' => 'http://localhost'
    assert_equal 'http://localhost', headers['Access-Control-Allow-Origin']
  end
end
