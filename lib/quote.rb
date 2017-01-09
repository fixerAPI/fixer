# frozen_string_literal: true
require 'currency'

class Quote
  Invalid = Class.new(StandardError)

  DEFAULT_AMOUNT = 1
  DEFAULT_BASE = 'EUR'

  attr_reader :amount, :base, :date

  def initialize(params = {})
    self.amount = params['amount']
    self.base = params.values_at(:base, :from).compact.first
    self.date = params[:date]
  end

  def rates
    @rates ||= find_rates
  end

  def attributes
    { base: base, date: date, rates: rates }
  end

  alias to_h attributes

  private

  def amount=(value)
    @amount = (value || DEFAULT_AMOUNT).to_f
    raise Invalid, 'Invalid amount' if @amount.zero?
  end

  def base=(value)
    @base = value&.upcase || DEFAULT_BASE
  end

  def date=(value)
    @date = value ? Currency.current_date_before(value) : Currency.current_date
    raise Invalid, 'Date too old' unless @date
  rescue Sequel::DatabaseError => ex
    raise Invalid, 'Invalid date' if ex.wrapped_exception.is_a?(PG::DataException)
    raise
  end

  def find_rates
    quoted_against_default_base? ? find_default_rates : find_rebased_rates
  end

  def quoted_against_default_base?
    base == DEFAULT_BASE
  end

  def find_default_rates
    Currency.where(date: date).reduce({}) do |rates, currency|
      rates.update(Hash[currency.to_h.map { |k, v| [k, round_rate(v * amount)] }])
    end
  end

  def find_rebased_rates
    rates = find_default_rates
    denominator = rates.update(DEFAULT_BASE => amount).delete(base)
    raise Invalid, 'Invalid base' unless denominator
    rates.each do |iso_code, rate|
      rates[iso_code] = round_rate(amount * rate / denominator)
    end

    rates
  end

  # I'm mimicking the apparent convention of the ECB here.
  def round_rate(rate)
    Float(format('%.5g', rate))
  end
end
