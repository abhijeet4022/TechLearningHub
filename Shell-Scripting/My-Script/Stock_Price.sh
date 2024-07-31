#!/bin/bash

# URLs of the Moneycontrol pages for Nifty 50 and Nifty Midcap 100
URL_NIFTY_50="https://www.moneycontrol.com/indian-indices/nifty-50-9.html"
URL_NIFTY_MIDCAP_100="https://www.moneycontrol.com/indian-indices/cnx-midcap-27.html"

# Fetch the previous close value for Nifty 50
previous_close_nifty_50=$(curl -s "$URL_NIFTY_50" | grep -i "previousclose" | awk -F'<span id="sp_previousclose">' '{print $2}' | awk -F'</span>' '{print $1}')

# Fetch the previous close value for Nifty Midcap 100
previous_close_nifty_midcap_100=$(curl -s "$URL_NIFTY_MIDCAP_100" | grep -i "previousclose" | awk -F'<span id="sp_previousclose">' '{print $2}' | awk -F'</span>' '{print $1}')

# Get the previous day's date in the format YYYY-MM-DD
previous_date=$(date -d "yesterday" '+%Y-%m-%d')

# Check if the Nifty 50 price was extracted successfully
if [ -z "$previous_close_nifty_50" ]; then
  echo "Failed to fetch Nifty 50 previous close value."
else
  echo "Nifty 50 Previous Close Value on $previous_date: $previous_close_nifty_50"
fi

# Check if the Nifty Midcap 100 price was extracted successfully
if [ -z "$previous_close_nifty_midcap_100" ]; then
  echo "Failed to fetch Nifty Midcap 100 previous close value."
else
  echo "Nifty Midcap 100 Previous Close Value on $previous_date: $previous_close_nifty_midcap_100"
fi
