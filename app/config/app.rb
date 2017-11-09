# frozen_string_literal: true

require 'pathname'

# Encapsulates app configuration
module App
  class << self
    def env
      ENV['RACK_ENV'] || 'development'
    end

    def root
      Pathname.new(File.expand_path('..', __dir__))
    end
  end
end
