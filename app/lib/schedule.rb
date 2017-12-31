# frozen_string_literal: true

require 'bank'
require 'rufus-scheduler'

schedule = Rufus::Scheduler.new

schedule.cron '*/15 15,16,17 * * 1-5' do
  Bank.fetch_current_rates!
end

schedule.join
