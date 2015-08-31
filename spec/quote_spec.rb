require_relative 'helper'
require 'quote'

describe Quote do
  def stub_rates(default_rates = {})
    quote.stub :find_default_rates, default_rates do
      yield quote
    end
  end

  describe 'by default' do
    let(:quote) { Quote.new }

    it 'quotes rates against the euro' do
      stub_rates 'USD' => 1.25 do |quote|
        rate = quote.rates['USD']
        rate.must_equal 1.25
      end
    end

    it 'does not quote the euro' do
      stub_rates do |quote|
        quote.rates.keys.wont_include 'EUR'
      end
    end

    it 'casts to hash' do
      stub_rates do |quote|
        %i(base date rates).each do |key|
          quote.to_h.keys.must_include key
        end
      end
    end
  end

  describe 'when base is set to a non-euro currency' do
    let(:quote) { Quote.new(base: 'USD') }

    it 'quotes rates against that currency' do
      stub_rates 'USD' => 1.25 do |quote|
        rate = quote.rates['EUR']
        rate.must_equal 0.8
      end
    end

    it 'does not quote the base currency' do
      stub_rates 'USD' => 1.25 do |quote|
        quote.rates.keys.wont_include 'USD'
      end
    end
  end
end
