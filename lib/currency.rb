class Currency < Sequel::Model
  def self.last_date
    order(:date).last.date
  end

  def to_hash
    { iso_code => rate }
  end
end
