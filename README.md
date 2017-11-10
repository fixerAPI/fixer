# Fixer

[![Travis](https://travis-ci.org/hakanensari/fixer.svg)](https://travis-ci.org/hakanensari/fixer)

Fixer is a free API for current and historical foreign exchange rates [published by the European Central Bank](https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/index.en.html).

A public instance of the API lives at [https://api.fixer.io](https://api.fixer.io). Alternatively, you can run  privately with the provided Docker image.

Rates are updated around 4PM CET every working day.

## Usage

Get the latest foreign exchange rates.

```http
GET /latest
```

Get historical rates for any day since 1999.

```http
GET /2000-01-03
```

Rates are quoted against the Euro by default. Quote against a different currency by setting the base parameter in your request.

```http
GET /latest?base=USD
```

Request specific exchange rates by setting the symbols parameter.

```http
GET /latest?symbols=USD,GBP
```

The primary use case is client side. For instance, with [money.js](https://openexchangerates.github.io/money.js/) in the browser

```js
let demo = () => {
  let rate = fx(1).from("GBP").to("USD")
  alert("£1 = $" + rate.toFixed(4))
}

fetch('https://api.fixer.io/latest')
  .then((resp) => resp.json())
  .then((data) => fx.rates = data.rates)
  .then(demo)
```

## Installation

To run locally with Docker, type

```bash
docker-compose up -d
```

Then seed data with

```bash
docker-compose run web rake db:migrate rates:load
```

Now you can access the API at

```
http://localhost:8080
```

In production, create a [`.env`](.env.example) file in the project root first and then run above Docker commands with the production configuration file. For instance

```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up
```
