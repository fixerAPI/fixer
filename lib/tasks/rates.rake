require 'currency'
require 'fixer'

namespace :rates do
  desc 'Reload all rates'
  task :reload do
    Currency.delete
    data = Fixer::Feed.new(:historical)
    Currency.multi_insert(data.to_a)
  end

  desc 'Update rates'
  task :update do
    Fixer::Feed.new.each do |hsh|
      Currency.find_or_create(hsh)
    end
  end
end
