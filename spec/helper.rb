ENV['RACK_ENV'] = 'test'
require './config/environment'
require 'minitest/autorun'
require 'minitest/benchmark' if ENV['BENCH']
require 'minitest/pride'
