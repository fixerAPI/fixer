# frozen_string_literal: true

Dir.glob('lib/tasks/*.rake').each { |r| import r }
task default: %w(db:migrate rates:load test rubocop)
