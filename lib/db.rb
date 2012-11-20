require 'sequel'

Sequel.connect ENV['DATABASE_URL'] || 'postgres://localhost/fixer'

class Currency < Sequel::Model
  def self.last_date
    order(:date).last.date
  end

  def to_hash
    { iso_code => rate }
  end
end
