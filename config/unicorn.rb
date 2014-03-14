preload_app true
worker_processes 4
timeout 10

before_fork do |_, _|
  Sequel::DATABASES.each { |db| db.disconnect }
end
