$: << 'lib'

require 'fixer'
require 'rake/testtask'
require 'db'

task :load do
  Currency.delete
  data = Fixer::Feed.new(:historical)
  Currency.multi_insert(data.to_a)
end

task :update do
  Fixer::Feed.new.each do |hsh|
    Currency.find_or_create(hsh)
  end
end

Rake::TestTask.new do |t|
  t.libs.push('lib')
  t.test_files = FileList['spec/*_spec.rb']
  t.verbose = true
end

task :default => [:test]
