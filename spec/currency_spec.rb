# frozen_string_literal: true

require_relative 'helper'
require 'currency'

describe Currency do
  around do |test|
    Currency.db.transaction do
      test.call
      raise Sequel::Rollback
    end
  end

  before do
    Currency.dataset.delete
    @first = Currency.create(date: '2014-01-01')
    @last = Currency.create(date: '2015-01-01')
  end

  it 'returns current date' do
    Currency.current_date.must_equal @last.date
  end

  it 'returns current date before given date' do
    Currency.current_date_before(@last.date - 1).must_equal @first.date
  end

  it 'returns nil if there is no current date before given date' do
    Currency.current_date_before(@first.date - 1).must_be_nil
  end

  it 'casts to hash' do
    @first.to_h.must_be_kind_of Hash
  end
end
