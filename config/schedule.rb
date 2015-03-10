job_type :rake, 'cd :path && foreman run bundle exec rake :task --silent :output'

every '0 13,14,15,16,17 * * 1-5' do
  rake "rates:update"
end
