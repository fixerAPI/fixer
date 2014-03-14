$: << 'lib'

require 'fixer'
require 'rake/testtask'
require 'db'

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

Rake::TestTask.new do |t|
  t.libs.push('lib')
  t.test_files = FileList['spec/*_spec.rb']
  t.verbose = true
end

namespace :db do
  desc 'Run database migrations'
  task :migrate do
    Sequel.extension(:migration)
    db = Sequel::DATABASES.first
    dir = App.root.join('db/migrate')
    opts = {}
    opts.update(target: ENV['VERSION'].to_i) if ENV['VERSION']

    Sequel::IntegerMigrator.new(db, dir, opts).run
  end
end

task :default => [:test]
