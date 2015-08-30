require_relative 'helper'
require 'quote'

describe Quote do
  def stub_rates(rates = {})
    quote.stub :rates, rates do
      yield quote.to_h[:rates]
    end
  end

  describe 'by default' do
    let(:quote) { Quote.new }

    it 'quotes rates against the euro' do
      stub_rates 'USD' => 1.25 do |quotes|
        quotes['USD'].must_equal 1.25
      end
    end

    it 'does not quote the euro' do
      stub_rates do |quotes|
        quotes.keys.wont_include 'EUR'
      end
    end
  end

  describe 'when base is set to a non-euro currency' do
    let(:quote) { Quote.new(base: 'USD') }

    it 'quotes rates against that currency' do
      stub_rates 'USD' => 1.25 do |quotes|
        quotes['EUR'].must_equal 0.8
      end
    end

    it 'does not quote the base currency' do
      stub_rates 'USD' => 1.25 do |quotes|
        quotes.keys.wont_include 'USD'
      end
    end
  end
end
