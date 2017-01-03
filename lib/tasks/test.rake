# frozen_string_literal: true

return unless ENV['RACK_ENV'] == 'test'

require 'rake/testtask'
require 'rubocop/rake_task'

Rake::TestTask.new(test: :environment) do |t|
  t.libs.push('lib')
  t.test_files = FileList['spec/*_spec.rb']
  t.ruby_opts += ['-W0']
end

RuboCop::RakeTask.new

task default: %w(db:migrate rates:load test rubocop)
