# shellfolio

shellfolio is a cryptocurrency portfolio manager and price tracker for the CLI. It gathers it's information from coinmarketcap.com, calculates what your coins are worth and presents the results on the shell:

![screenshot](/screenshot.png?raw=true "screenshot")

# Installation

* Copy the file _.shellfolio_ into your home directory
* Copy the file _shellfolio.sh_ into a directory that is in you PATH variable
* Set the correct file permissions: _chmod u+x shellfolio.sh_


# Configuration

Edit the file _~/.shellfolio_ like this:

```
COINS="ethereum ripple stellar iota cardano digibyte neo nem dogecoin"
ETH=4.3
XRP=234
XLM=3984
MIOTA=389
ADA=821
DGB=9821
NEO=10.3
XEM=821
DOGE=987324
```

The variable $COINS defines all coins you want to be listed, must be referenced by their name. All other variables are coins you own (must be the ticker name), their value represents the amount you have.
