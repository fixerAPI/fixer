# frozen_string_literal: true

namespace :rates do
  desc 'Reload all rates'
  task reload: :environment do
    require 'bank'
    Bank.fetch_all_rates!
  end

  desc 'Update current rates'
  task update: :environment do
    require 'bank'
    Bank.fetch_current_rates!
  end
end
