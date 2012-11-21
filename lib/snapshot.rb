require_relative 'db'
require 'yajl'

class Snapshot
  def self.last
    new Currency.last_date
  end

  def initialize(date)
    @date = date
  end

  def to_base(base)
    {
      base:  base,
      date:  @date,
      rates: rates
    }
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
