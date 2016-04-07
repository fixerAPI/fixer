# Fixer.io

[![Travis](https://travis-ci.org/hakanensari/fixer-io.svg)](https://travis-ci.org/hakanensari/fixer-io)

<img src="http://fixer.io/img/money.png" alt="fixer" width=180 align="middle">

Fixer.io is a free JSON API for current and historical foreign exchange rates published by the European Central Bank.

The rates are updated daily around 3PM CET.


## Docker


```
# bring the stack up
docker-compose up -d
# initialize the database (postgres need a short time to come up)
docker-compose run fixer rake db:migrate rates:load
```
