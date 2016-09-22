# frozen_string_literal: true

require 'bigdecimal'
require 'quote'

class Converter
  attr_reader :to, :from

  def initialize(params = {})
    @amount = params[:amount]
    @from   = params[:from]
    @to     = params[:to]
  end

  # Converts an amount into a new currency
  # @param quote [Quote] the quote object
  # @return amount [BigDecimal] the converted amount
  def convert(quote = latest_quote)
    return amount if quote.base == to
    amount * quote.rates.fetch(to) { raise Quote::Invalid, 'Invalid to' }
  end

  def amount
    BigDecimal(@amount.to_s)
  end

  private

  def latest_quote
    @latest_quote ||= Quote.new(base: from)
  end
end
