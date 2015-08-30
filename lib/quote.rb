require 'virtus'
require 'currency'

class Quote
  include Virtus.value_object

  DEFAULT_BASE = 'EUR'

  values do
    attribute :base, String, default: DEFAULT_BASE
    attribute :date, Date, default: Currency.current_date
  end

  def to_h
    attributes.merge(rates: rebase(rates))
  end

  private

  def date=(date)
    current_date = Currency.current_date_before(date)
    fail ArgumentError, 'Date too old' unless current_date

    super current_date
  end

  def rates
    Currency.where(date: date).reduce({}) do |rates, currency|
      rates.update(currency.to_hash)
    end
  end

  def rebase(rates)
    if base.upcase! != DEFAULT_BASE
      denominator = rates.update(DEFAULT_BASE => 1.0).delete(base)
      fail ArgumentError, 'Invalid base' unless denominator
      rates.each do |iso_code, rate|
        rates[iso_code] = round(rate / denominator)
      end
    end

    rates
  end

  def round(rate)
    if rate > 100
      rate.round(2)
    elsif rate > 10
      rate.round(3)
    else
      rate.round(4)
    end
  end
end
