# frozen_string_literal: true

require_relative 'helper'
require 'rack/test'
require 'api'

describe 'the API' do
  include Rack::Test::Methods

  let(:app)  { Sinatra::Application }
  let(:json) { Oj.load(last_response.body) }

  it 'handles unfound pages' do
    get '/foo'
    last_response.status.must_equal 404
    json.wont_be_empty
  end

  it 'will not process an invalid date' do
    get '/2010-31-01'
    last_response.must_be :unprocessable?
    json.wont_be_empty
  end

  it 'will not process a date before 2000' do
    get '/1999-01-01'
    last_response.must_be :unprocessable?
    json.wont_be_empty
  end

  it 'will not process an invalid base' do
    get '/latest?base=UAH'
    last_response.must_be :unprocessable?
    json.wont_be_empty
  end

  it 'handles malformed queries' do
    get '/latest?base=USD?callback=?'
    last_response.must_be :unprocessable?
    json.wont_be_empty
  end

  it 'returns fresh dates' do
    Currency.db.transaction do
      new_date = Currency.current_date + 1
      Currency.create(date: new_date, iso_code: 'FOO', rate: 1)
      get '/latest'
      json['date'].must_equal new_date.to_s
      raise Sequel::Rollback
    end
  end
end
