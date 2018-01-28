#!/usr/pkg/bin/bash

. ~/.shellfolio

minus=$(tput setaf 1)
plus=$(tput setaf 2)
neutral=$(tput sgr0)
colwidths="$neutral%5s %14s %7s %7s %7s %12s %12s %12s\n"
totalvalue=0
totalgain=0

# checks if value is positive or negative, returns color code
colorize() {
        if [[ $1 == *"-"* ]]; then
                color=$minus
        else
                color=$plus
        fi
        echo $color
}

# print table header
printf "${colwidths}" "Coin" "USD" "+/- 1h" "+/- 24h" "+/- 7d" "Amount" "Value" "Gain"
printf "${colwidths}" "-----" "--------------" "-------" "-------" "-------" "------------" "------------" "------------"

# print one line per coin
for coin in $COINS
do
        # fetch data from coinmarketcap.com
        result=$(curl -s -XGET "https://api.coinmarketcap.com/v1/ticker/$coin/?convert=usd")
        if [[ $currency != *"error"* ]]; then
                symbol=$(echo $result | jq ".[0].symbol" | xargs printf "%s\n")
                change1h=$(echo $result | jq ".[0].percent_change_1h" | xargs printf "%.*f\n" 2)
                change24h=$(echo $result | jq ".[0].percent_change_24h" | xargs printf "%.*f\n" 2)
                change7d=$(echo $result | jq ".[0].percent_change_7d" | xargs printf "%.*f\n" 2)
                usd=$(echo $result | jq ".[0].price_usd" | xargs printf "%.*f\n" 8)
                
                # set color to green or red 
                col1h=$(colorize $change1h)
                col24h=$(colorize $change24h)
                col7d=$(colorize $change7d)
                
                # check if $symbol is set, split into $amount and $paid
                if [ -z ${!symbol} ]; then
                        amount=0
                        paid=0
                else
                        IFS=: read -r amount paid <<< "${!symbol}"      
                fi
                
                # calculates value of coins
                value=$(echo "scale=2; $amount*$usd" | bc)
                usd=$(echo "scale=2; $usd" | bc)
                totalvalue=$(echo "scale=2; $value+$totalvalue" | bc)

                # calculates gain               
                if  [ "$paid" -eq "0" ]; then
                        gain=0
                else
                        gain=$(echo "scale=2; $value-$paid" | bc)
                fi
                colgain=$(colorize $gain)
                totalgain=$(echo "scale=2; $gain+$totalgain" | bc)
                
                # prints actual table line
                printf "$neutral%5s %14.6f $col1h%7s $col24h%7s $col7d%7s $neutral%12s %12.2f $colgain%12.2f$neutral\n" "$symbol" "$usd" "$change1h%" "$change24h%" "$change7d%" "$amount" "$value" "$gain"
        fi

done

# prints table footer
printf "${colwidths}" "-----" "--------------" "-------" "-------" "-------" "------------" "------------" "------------"

#prints total coin value and total gain
colgain=$(colorize $totalgain)
printf "%70.2f $colgain%12.2f$neutral\n" "$totalvalue" "$totalgain"

exit 0
