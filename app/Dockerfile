FROM ruby:2.5.0

RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install --jobs=8 --without development
ADD . /app
CMD ["unicorn", "-c", "./config/unicorn.rb"]
