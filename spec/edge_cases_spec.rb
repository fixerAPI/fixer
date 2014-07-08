require_relative 'helper'
require 'rack/test'
require 'api'

describe 'the API' do
  include Rack::Test::Methods

  let(:app)  { Sinatra::Application }

  it 'handles unfound pages' do
    get '/foo'
    last_response.status.must_equal 404
  end

  it 'will not process an invalid date' do
    get '/2010-31-01'
    last_response.must_be :unprocessable?
  end

  it 'will not process a date before 2000' do
    get '/1999-01-01'
    last_response.must_be :unprocessable?
  end

  it 'will not process an invalid base' do
    get '/latest?base=UAH'
    last_response.must_be :unprocessable?
  end

  it 'handles malformed queries' do
    get 'latest?base=USD?callback=?'
    last_response.must_be :unprocessable?
  end
end
