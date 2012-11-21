require_relative 'db'

class Snapshot
  DEFAULT_BASE = 'EUR'

  def self.last
    new Currency.last_date
  end

  def initialize(date)
    @date = date
    @base = DEFAULT_BASE
  end

  # Ugly as fuck.
  def to_hash
    rebased_rates = rates

    unless @base == DEFAULT_BASE
      base_rate = rebased_rates
        .update('EUR' => 1.0)
        .delete @base

      rebased_rates.each do |iso_code, rate|
        new_rate = rate / base_rate
        rebased_rates[iso_code] =
          case new_rate
          when new_rate > 100
            new_rate.round 2
          when new_rate > 10
            new_rate.round 3
          else
            new_rate.round 4
          end
      end
    end

    {
      base:  @base,
      date:  @date,
      rates: rebased_rates
    }
  end

  def with_base(base)
    @base = base
    self
  end

  private

  def rates
    Currency
      .where(date: @date)
      .reduce({}) { |hsh, currency|
        hsh.update currency.to_hash
      }
  end
end
