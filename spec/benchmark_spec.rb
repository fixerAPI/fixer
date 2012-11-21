require_relative 'helper'
require 'rack/test'
require 'app'

describe 'benchmark the app' do
  include Rack::Test::Methods

  let(:app) { Sinatra::Application }

  bench_performance_constant 'latest' do
    100.times do
      get '/latest'
    end
  end

  bench_performance_constant 'latest base' do
    100.times do
      get '/latest?base=USD'
    end
  end

  bench_performance_constant 'historical' do
    100.times do
      random_date = Date.today - rand(4000)
      get "/#{random_date}"
    end
  end

  bench_performance_constant 'historical base' do
    100.times do
      random_date = Date.today - rand(4000)
      get "/#{random_date}?base=USD"
    end
  end
end
