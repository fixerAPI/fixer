require 'virtus'
require 'currency'

class Quote
  include Virtus.value_object

  DEFAULT_BASE = 'EUR'

  values do
    attribute :base, String, default: DEFAULT_BASE
    attribute :date, Date, default: proc { Currency.current_date }
    attribute :rates, Hash, default: :find_rates, lazy: true
  end

  private

  def base=(base)
    base.upcase!
    super base
  end

  def date=(date)
    current_date = Currency.current_date_before(date)
    fail ArgumentError, 'Date too old' unless current_date

    super current_date
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
    fail ArgumentError, 'Invalid base' unless denominator
    rates.each do |iso_code, rate|
      rates[iso_code] = round_rate(rate / denominator)
    end

    rates
  end

  # I'm mimicking the apparent convention of the ECB here.
  def round_rate(rate)
    Float("%.#{5}g" % rate)
  end
end
