#!/usr/pkg/bin/bash

. ~/.shellfolio

minus=$(tput setaf 1)
plus=$(tput setaf 2)
neutral=$(tput sgr0)
colwidths="$neutral%6s %15s %8s %8s %8s %12s %12s\n"
total=0

colorize() {
        if [[ $1 == *"-"* ]]; then
                color=$minus
        else
                color=$plus
        fi
        echo $color
}


printf "${colwidths}" "Symbol" "USD" "+/- 1h" "+/- 24h" "+/- 7d" "Amount" "Value"
printf "${colwidths}" "------" "---------------" "--------" "--------" "--------" "------------" "------------"

for coin in $COINS
do
        result=$(curl -s -XGET "https://api.coinmarketcap.com/v1/ticker/$coin/?convert=usd")
        if [[ $currency != *"error"* ]]; then
                symbol=$(echo $result | jq ".[0].symbol" | xargs printf "%s\n")
                change1h=$(echo $result | jq ".[0].percent_change_1h" | xargs printf "%.*f\n" 2)
                change24h=$(echo $result | jq ".[0].percent_change_24h" | xargs printf "%.*f\n" 2)
                change7d=$(echo $result | jq ".[0].percent_change_7d" | xargs printf "%.*f\n" 2)
                usd=$(echo $result | jq ".[0].price_usd" | xargs printf "%.*f\n" 8)

                col1h=$(colorize $change1h)
                col24h=$(colorize $change24h)
                col7d=$(colorize $change7d)

                if [ -z ${!symbol} ]; then
                        amount=0
                else
                        amount=${!symbol}
                fi

                value=$(echo "scale=2; $amount*$usd" | bc)
                usd=$(echo "scale=2; $usd" | bc)
                total=$(echo "scale=2; $value+$total" | bc)

                printf "$neutral%6s %15.6f $col1h%8s $col24h%8s $col7d%8s $neutral%12s %12.2f\n" "$symbol" "$usd" "$change1h%" "$change24h%" "$change7d%" "$amount" "$value"
        fi

done

printf "${colwidths}" "------" "---------------" "--------" "--------" "--------" "------------" "------------"
printf "%75.2f\n" "$total"

exit 0
