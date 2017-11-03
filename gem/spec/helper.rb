# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require 'minitest/autorun'
require 'vcr'
require 'webmock'

require 'fixer'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
end
