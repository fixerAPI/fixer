# frozen_string_literal: true

require 'currency'
require 'fixer'

module Bank
  def self.fetch_all_rates!
    Currency.db.transaction do
      Currency.dataset.delete
      data = Fixer.historical
      Currency.multi_insert(data.to_a)
    end
  end

  def self.fetch_current_rates!
    Currency.db.transaction do
      Fixer.current.each do |hsh|
        Currency.find_or_create(hsh)
      end
    end
  end
end
