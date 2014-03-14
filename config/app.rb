require 'logger'
require 'pathname'

module App
  class << self
    attr :logger

    def env
      ENV['RACK_ENV'] || 'development'
    end

    def root
      Pathname.pwd
    end
  end

  @logger = Logger.new(STDOUT)
end
