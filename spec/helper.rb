# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'
require './config/environment'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/around/spec'
