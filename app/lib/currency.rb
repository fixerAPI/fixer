# frozen_string_literal: true

class Currency < Sequel::Model
  dataset_module do
    def recent
      order(Sequel.desc(:date))
    end

    def before(value)
      where { date <= value }
    end

    def current_date
      recent.first&.date
    end

    def current_date_before(value)
      before(value).current_date
    end
  end

  def to_h
    { iso_code => rate }
  end
end
