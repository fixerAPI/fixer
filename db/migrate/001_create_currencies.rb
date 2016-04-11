# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :currencies do
      Date    :date
      String  :iso_code
      Float   :rate

      index [:date, :iso_code], unique: true
    end
  end
end
