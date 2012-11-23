require_relative 'helper'
require 'snapshot'

describe Snapshot do
  let(:snapshot) { Snapshot.new }

  def stub_rates(rates = {})
    snapshot.stub :rates, rates do
      yield snapshot.quote[:rates]
    end
  end

  describe 'by default' do
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
    before do
      snapshot.base = 'USD'
    end

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
