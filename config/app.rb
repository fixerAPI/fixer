require 'logger'
require 'pathname'

# Encapsulates app configuration
module App
  class << self
    attr_reader :logger

    def env
      ENV['RACK_ENV'] || 'development'
    end

    def root
      Pathname.pwd
    end

    def version
      `git rev-parse --short HEAD 2>/dev/null`.strip!
    end
  end

  @logger = Logger.new(STDOUT)
end
