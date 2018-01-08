# frozen_string_literal: true

require 'rake/testtask'
begin
  require 'rubocop/rake_task'
rescue LoadError
  return
end

Rake::TestTask.new(test: :environment) do |t|
  t.libs.push('lib')
  t.test_files = FileList['spec/*_spec.rb']
  t.ruby_opts += ['-W0']
end

RuboCop::RakeTask.new

task default: %w[db:setup test rubocop]
