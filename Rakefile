require_relative 'lib/db'
require 'fixer'
require 'rake/testtask'

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

Rake::TestTask.new do |t|
  t.libs.push 'lib'
  t.test_files = FileList['spec/*_spec.rb']
  t.verbose = true
end

task :default => [:test]
