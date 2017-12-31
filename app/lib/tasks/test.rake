# frozen_string_literal: true

return if ENV['RACK_ENV'] == 'production'

require 'rake/testtask'
require 'rubocop/rake_task'

Rake::TestTask.new(test: :environment) do |t|
  t.libs.push('lib')
  t.test_files = FileList['spec/*_spec.rb']
  t.ruby_opts += ['-W0']
end

RuboCop::RakeTask.new

task default: %w[db:migrate rates:reload test rubocop]
