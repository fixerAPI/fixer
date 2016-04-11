namespace :rates do
  task setup: :environment do
    require 'currency'
    require 'fixer'
  end

  desc 'Load all rates'
  task load: :setup do
    Currency.db.transaction do
      Currency.dataset.delete
      data = Fixer::Feed.new(:historical)
      Currency.multi_insert(data.to_a)
    end
  end

  desc 'Update rates'
  task update: :setup do
    Fixer::Feed.new.each do |hsh|
      Currency.find_or_create(hsh)
    end
  end
end
