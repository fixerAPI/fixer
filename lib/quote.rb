# frozen_string_literal: true

require 'currency'

class Quote
  Invalid = Class.new(StandardError)

  DEFAULT_BASE = 'EUR'

  attr_reader :base, :date

  def initialize(params = {})
    self.base = params[:base]
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

  def base=(base)
    @base = base ? base.upcase : DEFAULT_BASE
  end

  def date=(date)
    current_date = date ? Currency.current_date_before(date) : Currency.current_date
    raise Invalid, 'Date too old' unless current_date
    @date = current_date
  rescue Sequel::DatabaseError => ex
    if ex.wrapped_exception.is_a?(PG::DatetimeFieldOverflow)
      raise Invalid, 'Invalid date'
    else
      raise
    end
  end

  def find_rates
    quoted_against_default_base? ? find_default_rates : find_rebased_rates
  end

  def quoted_against_default_base?
    base == DEFAULT_BASE
  end

  def find_default_rates
    Currency.where(date: date).reduce({}) do |rates, currency|
      rates.update(currency.to_h)
    end
  end

  def find_rebased_rates
    rates = find_default_rates
    denominator = rates.update(DEFAULT_BASE => 1.0).delete(base)
    raise Invalid, 'Invalid base' unless denominator
    rates.each do |iso_code, rate|
      rates[iso_code] = round_rate(rate / denominator)
    end

    rates
  end

  # I'm mimicking the apparent convention of the ECB here.
  def round_rate(rate)
    Float(format('%.5g', rate))
  end
end
