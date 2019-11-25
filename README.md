# cryptocurl
Cryptocurrency Investment Analyzer

Cryptocurrencies can be a great investment opportunity, however, bring a large volatility caused by various reasons such as uncertain regulation. Albeit not professional financial advice, our service aims to reduce the friction for new crypto currency investors by providing cryptocurrency recommendations based on market analysis.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

```
swipl
```

### Installing

```
swipl
[main].
invest(10000, bitcoin).
```
Our program will do multiple computations to provide an investment suggestion.

Here is an example input and output:

INPUT:
```
invest(10000, bitcoin).
```

OUTPUT:
```
Your budget is: 10000
The current price of bitcoin is: 6648.69
You'll be able to purchase: 1 bitcoin
CoinScore is: 87
PriceTrend is: -1
Right now is a good time to buy! Your investment has a chance to make between x2 to x10 gains within 1 - 5 years.
```

Note, our program also has various other predicates that can be ran individually, for example listing the most popular coins:
INPUT:
```
get_top_list().
```

OUTPUT:
```
Currently for the most popular coins in the market,
the price is:
bitcoin - 6649.30
ethereum - 134.02
litecoin - 43.13
monero - 46.47
neo - 8.52
dash - 48.73
```

Powered by CoinGecko API 

https://www.coingecko.com/api/documentations/v3
