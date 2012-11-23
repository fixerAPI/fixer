require_relative 'db'
require 'virtus'

class Snapshot
  include Virtus

  attribute :base,  String, default: 'EUR'
  attribute :date,  Date,   default: proc { Currency.last_date }

  def quote
    attributes.merge rates: rebase(rates)
  end

  private

  def rates
    Currency
      .where(date: date)
      .reduce({}) do |rates, currency|
        rates.update currency.to_hash
      end
  end

  # Ugly as fuck.
  def rebase(rates)
    if base.upcase! != 'EUR'
      denominator = rates
        .update('EUR' => 1.0)
        .delete base

      rates.each do |iso_code, rate|
        rates[iso_code] = round(rate / denominator)
      end
    end

    rates
  end

  def round(rate)
    case rate
    when rate > 100
      rate.round 2
    when rate > 10
      rate.round 3
    else
      rate.round 4
    end
  end
end
