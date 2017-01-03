# frozen_string_literal: true

require 'dalli'
require 'pathname'

# Encapsulates app configuration
module App
  class << self
    attr_reader :cache, :version, :released_at

    def env
      ENV['RACK_ENV'] || 'development'
    end

    def root
      Pathname.pwd
    end
  end

  @cache = Dalli::Client.new
  @released_at = `git show -s --format=%ci HEAD`
  @version = `git rev-parse --short HEAD 2>/dev/null`.strip!
end
