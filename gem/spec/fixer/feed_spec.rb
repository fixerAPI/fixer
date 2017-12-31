# frozen_string_literal: true

require_relative '../helper'

module Fixer
  describe Feed do
    before { VCR.insert_cassette 'fixer' }
    after  { VCR.eject_cassette }

    it 'parses the date of a currency' do
      feed = Feed.new(:current)
      currency = feed.first
      currency[:date].must_be_kind_of Date
    end

    it 'parse the ISO code of a currency' do
      feed = Feed.new(:current)
      currency = feed.first
      currency[:iso_code].must_be_kind_of String
    end

    it 'parses the rate of a currency' do
      feed = Feed.new(:current)
      currency = feed.first
      currency[:rate].must_be_kind_of Float
    end

    it 'fetches current rates' do
      feed = Feed.new(:current)
      feed.count.must_be :<, 40
    end

    it 'fetches rates for the past 90 days' do
      feed = Feed.new(:ninety_days)
      feed.count.must_be :>, 33 * 60
    end

    it 'fetches historical rates' do
      feed = Feed.new(:historical)
      feed.count.must_be :>, 33 * 3000
    end

    it 'raises error when scope is not valid' do
      -> { Feed.new(:invalid) }.must_raise ArgumentError
    end
  end
end
