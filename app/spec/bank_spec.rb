# frozen_string_literal: true

require_relative 'helper'
require 'bank'

describe Bank do
  around do |test|
    Currency.db.transaction do
      test.call
      raise Sequel::Rollback
    end
  end

  before do
    Currency.dataset.delete
  end

  it 'fetches current rates' do
    Bank.fetch_current_rates!
    Currency.count.must_be :positive?
  end
end
