# frozen_string_literal: true

namespace :rates do
  desc 'Load all rates'
  task load: :environment do
    require 'currency'
    require 'fixer'

    Currency.db.transaction do
      Currency.dataset.delete
      data = Fixer::Feed.new(:historical)
      Currency.multi_insert(data.to_a)
    end
  end

  desc 'Update rates'
  task update: :environment do
    require 'currency'
    require 'fixer'

    Fixer::Feed.new.each do |hsh|
      Currency.find_or_create(hsh)
    end
  end
end
