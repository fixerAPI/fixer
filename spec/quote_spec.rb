# frozen_string_literal: true

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

  describe 'when given a custom base' do
    let(:quote) { Quote.new(base: 'FOO') }

    it 'quotes rates against that currency' do
      stub_rates 'FOO' => 2 do |quote|
        quote.rates.keys.must_include 'EUR'
      end
    end

    it 'does not quote the base currency' do
      stub_rates 'FOO' => 2 do |quote|
        quote.rates.keys.wont_include 'FOO'
      end
    end

    it 'rounds to five significant digits' do
      stub_rates 'FOO' => 0.6995 do |quote|
        rate = quote.rates['EUR']
        rate.must_equal 1.4296
      end
    end
  end

  describe 'when given an invalid base' do
    let(:quote) { Quote.new(base: 'FOO') }

    it 'raises validation error' do
      proc { quote.to_h }.must_raise Quote::Invalid
    end
  end

  describe 'when given a date that is too old' do
    let(:quote) { Quote.new(date: '1900-01-01') }

    it 'raises validation error' do
      Currency.stub :current_date_before, nil do
        proc { quote }.must_raise Quote::Invalid
      end
    end
  end

  describe 'when given a bad date' do
    let(:quote) { Quote.new(date: '2000-31-01') }

    it 'raises validation error' do
      proc { quote }.must_raise Quote::Invalid
    end
  end
end
