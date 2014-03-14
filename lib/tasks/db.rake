namespace :db do
  desc 'Run database migrations'
  task migrate: :environment do
    Sequel.extension(:migration)
    db = Sequel::DATABASES.first
    dir = App.root.join('db/migrate')
    opts = {}
    opts.update(target: ENV['VERSION'].to_i) if ENV['VERSION']

    Sequel::IntegerMigrator.new(db, dir, opts).run
  end
end
