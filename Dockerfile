FROM ruby:2.3.0

ENV WORKER_PROCESSES 4
ENV DATABASE_URL postgres://postgres:mysecretpassword@postgres/fixer
ENV VERSION 1

RUN mkdir /fixer-io
WORKDIR /fixer-io
ADD Gemfile /fixer-io/Gemfile
ADD Gemfile.lock /fixer-io/Gemfile.lock
RUN bundle install --deployment --without development:test
ADD . /fixer-io

EXPOSE 8080

CMD bundle exec unicorn -p 8080 -c /fixer-io/config/unicorn.rb
