# frozen_string_literal: true

require_relative 'helper'
require 'converter'

describe Converter do
  let(:to) { 'USD' }
  let(:from) { 'EUR' }
  let(:amount) { '100.0' }

  let(:converter) { Converter.new to: to, from: from, amount: amount }
  let(:quote) { Quote.new }

  describe '#amount' do
    it 'casts to BigDecimal' do
      converter.amount.must_be_kind_of BigDecimal
    end
  end

  describe '#convert' do
    it 'should return the amount' do
      quote.stub :base, to do
        converter.convert(quote).must_equal BigDecimal(amount)
      end
    end

    it 'should use the rates to convert' do
      quote.stub :rates, Hash(to => 1.2) do
        converter.convert(quote).must_equal BigDecimal('120.0')
      end
    end

    it 'should raise with invalid currency' do
      quote.stub :rates, {} do
        -> { converter.convert(quote) }.must_raise Quote::Invalid, 'Invalid to'
      end
    end

    it 'should use latest quote as default' do
      quote.stub :rates, Hash(to => 1.3) do
        converter.stub :latest_quote, quote do
          converter.convert.must_equal 130.0
        end
      end
    end
  end
end
