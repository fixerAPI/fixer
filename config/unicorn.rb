# frozen_string_literal: true

preload_app true
worker_processes((ENV['WORKER_PROCESSES'] || 4).to_i)
timeout 10

before_fork do |_, _|
  Sequel::DATABASES.each(&:disconnect)
end
