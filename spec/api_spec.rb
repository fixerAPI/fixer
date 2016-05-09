# frozen_string_literal: true

require_relative 'helper'
require 'rack/test'
require 'api'

describe 'the API' do
  include Rack::Test::Methods

  let(:app)  { Sinatra::Application }
  let(:json) { Oj.load(last_response.body) }
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

  it 'returns a last modified header' do
    %w(/ /latest /2012-11-20).each do |path|
      get path
      headers['Last-Modified'].wont_be_nil
    end
  end

  it 'allows cross-origin requests' do
    %w(/ /latest /2012-11-20).each do |path|
      header 'Origin', '*'
      get path
      refute_empty headers['Access-Control-Allow-Methods']
    end
  end

  it 'responds to preflight requests' do
    %w(/ /latest /2012-11-20).each do |path|
      header 'Origin', '*'
      options path
      refute_empty headers['Access-Control-Allow-Methods']
    end
  end
end
