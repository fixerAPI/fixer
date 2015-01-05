Dir.glob('lib/tasks/*.rake').each { |r| import r }

task default: %w(db:migrate rates:reload test)
