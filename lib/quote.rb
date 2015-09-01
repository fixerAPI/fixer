require 'virtus'
require 'currency'

class Quote
  include Virtus.value_object

  NotValid = Class.new(ArgumentError)

  DEFAULT_BASE = 'EUR'

  values do
    attribute :base, String, default: DEFAULT_BASE
    attribute :date, Date, default: Currency.current_date
  end

  def rates
    @rates ||= find_rates
  end

  def attributes
    super.merge(rates: rates)
  end

  alias_method :to_h, :attributes

  private

  def base=(base)
    base.upcase!
    super base
  end

  def date=(date)
    current_date = Currency.current_date_before(date)
    fail NotValid, 'Date too old' unless current_date

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
    fail NotValid, 'Invalid base' unless denominator
    rates.each do |iso_code, rate|
      rates[iso_code] = round_rate(rate / denominator)
    end

    rates
  end

  def round_rate(rate)
    if rate > 100
      rate.round(2)
    elsif rate > 10
      rate.round(3)
    else
      rate.round(4)
    end
  end
end
