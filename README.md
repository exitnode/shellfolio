# shellfolio

shellfolio is a cryptocurrency portfolio manager and price tracker for the CLI. It gathers it's information from coinmarketcap.com, calculates what your coins are worth, what your gains and losses are and presents the results on the shell:

![screenshot](/screenshot2.png?raw=true "screenshot")

# Installation

* Copy the file _.shellfolio_ into your home directory
* Copy the file _shellfolio.sh_ into a directory that is in you PATH variable
* Set the correct file permissions: _chmod u+x shellfolio.sh_


# Configuration

Edit the file _~/.shellfolio_ like this:

```
COINS="ethereum ripple stellar iota cardano digibyte neo nem dogecoin bitcoin-cash"
ETH=4.3:233
XRP=23234:342
XLM=3984:533
MIOTA=3829.2:24333
ADA=821:324
DGB=9821:3454
NEO=10.3:99
XEM=821:123
DOGE=987324:435
BCH=20:2
```

The variable $COINS defines all coins you want to be listed, must be referenced by their name. All other variables are coins you own (must be the ticker name), their value represents the amount you have. Insert how much you invested (in USD)
after ":" in order to see your gains and losses.

In summary the variable definiton for each coin is:

$SYMBOL=amount:investment
