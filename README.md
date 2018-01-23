# shellfolio

shellfolio is a cryptocurrency portfolio manager and price tracker for the CLI. It gathers it's information from coinmarketcap.com, calculates what your coins are worth and presents the results on the shell:

```
[clemens@sdf.org:~/shellfolio]$ ./shellfolio.sh
Symbol        USD     +/- 1h    +/- 24h     +/- 7d     Amount      Value
------ ---------- ---------- ---------- ---------- ---------- ----------
   ETH    $937.29      0.22%     -8.05%    -15.12%        4.3   $4030.34
   XRP      $1.25      0.97%     -3.41%     -9.69%        234    $292.50
   XLM      $0.45      0.80%     -4.52%     -6.81%       3984   $1792.80
 MIOTA      $2.32      0.82%    -11.06%    -22.29%        389    $902.48
   ADA      $0.53      0.59%     -7.98%    -17.12%        821    $435.13
   DGB      $0.05      0.76%     -8.94%    -23.71%       9821    $491.05
   NEO    $113.40      0.66%    -10.15%    -25.84%       10.3   $1168.02
   XEM      $0.88     -1.82%    -13.41%    -22.14%        821    $722.48
  DOGE      $0.01     -1.58%    -10.06%    -20.83%     987324   $9873.24
------ ---------- ---------- ---------- ---------- ---------- ----------
                                                               $19708.04
```
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
