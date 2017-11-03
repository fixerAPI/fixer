# frozen_string_literal: true

require 'pg'
require 'sequel'

Sequel.single_threaded = true
Sequel.connect(ENV['DATABASE_URL'] || "postgres://localhost/fixer_#{App.env}")
