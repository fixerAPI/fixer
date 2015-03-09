every :hour do
  command "foreman run bundle exec rake rates:update"
end
