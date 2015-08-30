require 'virtus'
require 'currency'

# Quotes exchange rates on a specific date
class Snapshot
  include Virtus.model

  attribute :base, String, default: 'EUR'
  attribute :date, Date, default: Currency.current_date

  def quote
    self.date =
      if date
        last_date = Currency.current_date_before(date)
        fail ArgumentError, 'Date too old' unless last_date
        last_date
      end

    attributes.merge(rates: rebase(rates))
  end

  private

  def rates
    Currency.where(date: date).reduce({}) do |rates, currency|
      rates.update(currency.to_hash)
    end
  end

  def rebase(rates)
    if base.upcase! != 'EUR'
      denominator = rates.update('EUR' => 1.0).delete(base)
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
