every '0 13,14,15,16,17 * * 1-5' do
  command "foreman run bundle exec rake rates:update"
end
