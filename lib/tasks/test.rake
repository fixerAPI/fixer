require 'rake/testtask'

Rake::TestTask.new(test: :environment) do |t|
  t.libs.push('lib')
  t.test_files = FileList['spec/*_spec.rb']
  t.ruby_opts += ['-W1']
end
