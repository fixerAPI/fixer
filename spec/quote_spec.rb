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

  describe 'when given a non-euro base' do
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

  describe 'when given an invalid base' do
    let(:quote) { Quote.new(base: 'FOO') }

    it 'fails' do
      stub_rates 'USD' => 1.25 do |quote|
        proc { quote.to_h }.must_raise Quote::NotValid
      end
    end
  end

  describe 'when given a date that is too old' do
    let(:quote) { Quote.new(date: Date.new(1900)) }

    it 'fails' do
      Currency.stub :current_date_before, nil do
        proc { quote }.must_raise Quote::NotValid
      end
    end
  end
end
