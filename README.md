# Fixer.io

<img src="http://fixer.io/img/money.png" alt="fixer" width=180 align="middle">

[![Travis](https://travis-ci.org/hakanensari/fixer-io.svg)](https://travis-ci.org/hakanensari/fixer-io)

Fixer.io is a free JSON API for current and historical foreign exchange rates published by the European Central Bank.

The rates are updated daily around 3PM CET.

## Usage

Get the latest foreign exchange reference rates in JSON format.

```http
GET /latest
Host: api.fixer.io
```

Get historical rates for any day since 1999.

```http
GET /2000-01-03
Host: api.fixer.io
```

Rates are quoted against the Euro by default. Quote against a different currency by setting the base parameter in your request.

```http
GET /latest?base=USD
Host: api.fixer.io
```

Request specific exchange rates by setting the symbols or currencies parameter.

```http
GET /latest?symbols=USD,GBP
Host: api.fixer.io
```

Make cross-domain JSONP requests.

```http
GET /latest?callback=?
Host: api.fixer.io
```

An HTTPS endpoint is also available at [https://api.fixer.io](https://api.fixer.io).

Use [money.js](http://openexchangerates.github.io/money.js/) in the browser.

```js
var demo = function(data) {
  fx.rates = data.rates
  var rate = fx(1).from("GBP").to("USD")
  alert("£1 = $" + rate.toFixed(4))
}

$.getJSON("http://api.fixer.io/latest", demo)
```

## Docker

Bring the stack up.

```bash
docker-compose up -d
```

Initialize the database and seed data.

```bash
docker-compose run web rake db:migrate rates:load
```
