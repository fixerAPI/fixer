# Fixer -  Important Announcement

We are happy to announce the complete relaunch of fixer.io into a more stable, more secure, and much more advanced currency & exchange rate conversion API platform. While the core structure of our API remains unchanged, all users of the legacy Fixer API will be required to sign up for a free API access key and perform a few simple changes to their integration. To learn more about the changes that are required, please jump to the „Required Changes“ section below.

**Required Changes to Legacy Integrations (api.fixer.io)**

As of March 6th 2018, the legacy fixer API (api.fixer.io) is deprecated and a completely re-engineered API is now accessible at https://data.fixer.io/api/ The core structure of the old API has remained unchanged, and you will only need to perform a few simple changes to your integration.

1. Get a Free fixer Access Token
Go to fixer.io and create an account. After signup, you will receive an access token immediately. If you plan on using less than 1000 requests per month, your account will be completely free. If you need more or want to use some of our new features, you’ll need to choose one of the paid options.

2. Replace API URL and add Access Key
The new API is a complete drop-in replacement to the old API, but it has changed to a new endpoint and now requires an access key in the GET URL. Please change your API URL from api.fixer.io to https://data.fixer.io/api and attach your newly generated access key to the URL as a GET parameter named „access_key“. 

**Example**

If your old API Call was https://api.fixer.io/latest?base=USD then your new integration should point to: https://data.fixer.io/api/latest?base=USD&access_key=YOUR_ACCESS_KEY 

**New Features**

Although the core structure of the fixer API remains unchanged, we added a whole lot of improvements, 100+ more currencies, and many more features to the new Fixer API. You can read more about all new features on the new fixer.io website. Here’s a list of the most important ones:

- **Fixer is still free!**
Although we now offer a set of premium plans for more advanced users, all the features that you are used to from the legacy API are still completely free of charge. The only limitation is our new 1000 requests/month limit for customers using a free account. If you need more than 1000 requests per month, you’ll need to choose one of the paid plans starting at $10 per month.

- **Over 100 Additional Currencies**
The new Fixer API now supports over 100 additional currencies, bumping the total available currencies for conversion to 168.

- **More Reliable Data Sources & Updates every minute**
The old Fixer API was limited to currency data from the European Central Bank, which updates only once every day. The new API comes with 16+ connected data sources and data updates every hour, 10-minutes, or even every minute - depending on which subscription plan you choose.

- **More Endpoints**
The new fixer API has over 3 new endpoints, including a Direct Conversion endpoint, Time-Series conversion endpoint, and allows you to see the fluctuation of a specfic currency using our new Fluctuation endpoint. To learn more about all the new features, please head over to the API documentation at fixer.io/documentation 

**Next Steps**

- Discontinuation of the old API
We have no immediate timeline for switching off the old Fixer API. However, we will not provide support for it or develop it further at this stage. We will monitor the request volume on the legacy API and will make a decision on turning it off once request levels have dropped off. We will follow up with a clear timeline here on GitHub.

- Need help? Please get in touch
It’s very important for us to ensure a smooth transition to the new API Endpoint for all of our users. If you are a developer who has published a third-party plugin with Fixer, we recommend you to get in touch and share this announcement with your user base. If you need any help or have questions about the transition, please reach out at support@fixer.io 






[![Travis](https://travis-ci.org/hakanensari/fixer.svg)](https://travis-ci.org/hakanensari/fixer)

Fixer is a free API for current and historical foreign exchange rates [published by the European Central Bank](https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/index.en.html).

A public instance of the API lives at [https://api.fixer.io](https://api.fixer.io). Alternatively, you can run  privately with the provided [Docker image](https://hub.docker.com/r/hakanensari/fixer/).

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

I have included a sample Docker Compose configuration in the repo.

To build locally, type

```bash
docker-compose up -d
```

Now you can access the API at

```
http://localhost:8080
```

In production, create a [`.env`](.env.example) file in the project root and run with

```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```
