require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push('lib')
  t.test_files = FileList['spec/*_spec.rb']
end
