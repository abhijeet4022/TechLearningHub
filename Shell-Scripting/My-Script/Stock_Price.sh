#!/bin/bash

# URL of the Moneycontrol Nifty 50 page
URL="https://www.moneycontrol.com/indian-indices/nifty-50-9.html"

# Fetch the webpage content, use grep to find the previous close line, and then use awk to extract the value
previous_close=$(curl -s "$URL" | grep -i "previousclose" | awk -F'id="sp_previousclose">' '{print $2}' | awk -F'</span>' '{print $1}')

# Get the previous day's date in the format YYYY-MM-DD
previous_date=$(date -d "yesterday" '+%Y-%m-%d')

# Check if the price was extracted successfully
if [ -z "$previous_close" ]; then
  echo "Failed to fetch Nifty 50 previous close value."
else
  echo "Nifty 50 Previous Close Value on $previous_date: $previous_close"
fi
