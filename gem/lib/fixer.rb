# frozen_string_literal: true

require 'fixer/feed'

# ECB exchange rate datasets
#
# The three available short hands here are `.current`, `.ninety_days`, and
# `.historical`.
module Fixer
  class << self
    Feed::SCOPES.each_key do |scope|
      define_method(scope) do
        Feed.new(scope)
      end
    end
  end
end
