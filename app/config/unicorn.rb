# frozen_string_literal: true

worker_process_count = (ENV['WORKER_PROCESSES'] || 4).to_i

preload_app true
worker_processes worker_process_count
timeout 10

before_fork do |_, _|
  Sequel::DATABASES.each(&:disconnect)
end

fork do
  require_relative 'environment'
  require 'schedule'
end
