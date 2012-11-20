require_relative 'lib/db'
require 'fixer'

task :reset do
  data = Fixer::Feed.new(:historical).to_a

  Currency.delete
  Currency.multi_insert data
end

task :update do
  Fixer::Feed.new.each do |hsh|
    Currency.find_or_create hsh
  end
end
