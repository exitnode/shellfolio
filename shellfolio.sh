#!/usr/pkg/bin/bash

. ~/.shellfolio

# cell colors
minus=$(tput setaf 1)
plus=$(tput setaf 2)
neutral=$(tput sgr0)
# initial values
totalvalue=0
totalgain=0
maxsymbolw=3
maxusdw=8
maxchange1hw=5
maxchange24hw=5
maxchange7dw=5
maxamountw=6
maxvaluew=5
maxgainw=5
linewidth=80
# arrays
declare -a resultarr
declare -a symbol
declare -a change1h
declare -a change24h
declare -a change7d
declare -a usd
declare -a col1h
declare -a col24h
declare -a col7d
declare -a amount
declare -a paid
declare -a value
declare -a colgain
declare -a gain

# checks if value is positive or negative, returns color code
colorize() {
        if [[ $1 == *"-"* ]]; then
                color=$minus
        else
                color=$plus
        fi
        echo $color
}

# fetch data from coinmarketcap.com
i=0
for coin in $COINS
do
        resultarr[$i]=$(curl -s -XGET "https://api.coinmarketcap.com/v1/ticker/$coin/?convert=usd")
        ((++i))
done

# format and store result entries into arrays
i=0
for result in "${resultarr[@]}"
do
        symbol[$i]=$(echo $result | jq ".[0].symbol" | xargs printf "%s\n")
        change1h[$i]=$(echo $result | jq ".[0].percent_change_1h" | xargs printf "%.*f\n" 2)
        change24h[$i]=$(echo $result | jq ".[0].percent_change_24h" | xargs printf "%.*f\n" 2)
        change7d[$i]=$(echo $result | jq ".[0].percent_change_7d" | xargs printf "%.*f\n" 2)
        usd[$i]=$(echo $result | jq ".[0].price_usd" | xargs printf "%.*f\n" 8)
        col1h[$i]=$(colorize ${change1h[$i]})
        col24h[$i]=$(colorize ${change24h[$i]})
        col7d[$i]=$(colorize ${change7d[$i]})

        # check if $symbol is set, split into $amount and $paid
        if [ -z ${!symbol[$i]} ]; then
                amount[$i]=0
                paid[$i]=0
        else
                IFS=: read -r amount[$i] paid[$i] <<< "${!symbol[$i]}"
        fi

        # calculates value of coins
        value[$i]=$(echo "scale=2; ((${amount[$i]}*${usd[$i]}) * 100) / 100" | bc)
        usd[$i]=$(echo "scale=6; (${usd[$i]} * 100 ) / 100" | bc)
        totalvalue=$(echo "scale=2; ${value[$i]}+$totalvalue" | bc)

        # calculates gain
        if  [ "${paid[$i]}" -eq "0" ]; then
                gain[$i]=0
        else
                gain[$i]=$(echo "scale=2; ((${value[$i]}-${paid[$i]}) * 100) / 100" | bc)
        fi
        colgain[$i]=$(colorize ${gain[$i]})
        totalgain=$(echo "scale=2; ${gain[$i]}+$totalgain" | bc)

        # determine table column width
        if [ "${#symbol[$i]}" -gt "$maxsymbolw" ]; then maxsymbolw=${#symbol[$i]};fi
        if [ "${#usd[$i]}" -gt "$maxusdw" ]; then maxusdw=${#usd[$i]};fi
        if [ "${#change1h[$i]}" -gt "$maxchange1hw" ]; then maxchange1hw=${#change1h[$i]};fi
        if [ "${#change24h[$i]}" -gt "$maxchange24hw" ]; then maxchange24hw=${#change24h[$i]};fi
        if [ "${#change7d[$i]}" -gt "$maxchange7dw" ]; then maxchange7dw=${#change7d[$i]};fi
        if [ "${#amount[$i]}" -gt "$maxamountw" ]; then maxamountw=${#amount[$i]};fi
        if [ "${#value[$i]}" -gt "$maxvaluew" ]; then maxvaluew=${#value[$i]};fi
        if [ "${#gain[$i]}" -gt "$maxgainw" ]; then maxgainw=${#gain[$i]};fi
        if [ "${#totalgain}" -gt "$maxgainw" ]; then maxgainw=${#totalgain};fi
        if [ "${#totalvalue}" -gt "$maxvaluew" ]; then maxvaluew=${#totalvalue};fi

        ((++i))
done

# add 1 space for % symbol
((++maxchange1hw))
((++maxchange24hw))
((++maxchange7dw))

linewidth=$((8 + $maxsymbolw + $maxusdw + $maxchange1hw + $maxchange24hw + $maxchange7dw + $maxamountw + $maxvaluew + $maxgainw))

# print table header captions
printf "$neutral%${maxsymbolw}s  %${maxusdw}s %${maxchange1hw}s %${maxchange24hw}s %${maxchange7dw}s %${maxamountw}s %${maxvaluew}s %${maxgainw}s\n" "Coin" "USD" "1h" "24h" "7d" "Amount" "Value" "Gain"

# print table header line
seq -s- ${linewidth}|tr -d '[:digit:]'
printf "\n"

# print one line per coin
i=0
for result in "${resultarr[@]}"
do
        printf "$neutral%${maxsymbolw}s  %${maxusdw}.6f ${col1h[$i]}%${maxchange1hw}s ${col24h[$i]}%${maxchange24hw}s ${col7d[$i]}%${maxchange7dw}s $neutral%${maxamountw}s %${maxvaluew}.2f ${colgain[$i]}%${maxgainw}.2f$neutral\n" "${symbol[$i]}" "${usd[$i]}" "${change1h[$i]}%" "${change24h[$i]}%" "${change7d[$i]}%" "${amount[$i]}" "${value[$i]}" "${gain[$i]}"
        ((++i))
done

# prints table footer line
seq -s- ${linewidth}|tr -d '[:digit:]'
printf "\n"

totalvalpos=$(($linewidth - $maxgainw - 1))

#prints total coin value and total gain
colgain=$(colorize $totalgain)
printf "%${totalvalpos}.2f $colgain%${maxgainw}.2f$neutral\n" "$totalvalue" "$totalgain"

exit 0
