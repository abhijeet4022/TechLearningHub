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

# ANSI color codes
RED='\e[31m'
GREEN='\e[32m'
NC='\e[0m' # No Color

# Check if the Nifty 50 price was extracted successfully
if [ -z "$previous_close_nifty_50" ]; then
  echo -e "${RED}Failed to fetch Nifty 50 previous close value.${NC}"
else
  echo -e "Nifty 50 Previous Close Value on $previous_date: ${GREEN}$previous_close_nifty_50${NC}"
fi

# Check if the Nifty Midcap 100 price was extracted successfully
if [ -z "$previous_close_nifty_midcap_100" ]; then
  echo -e "${RED}Failed to fetch Nifty Midcap 100 previous close value.${NC}"
else
  echo -e "Nifty Midcap 100 Previous Close Value on $previous_date: ${GREEN}$previous_close_nifty_midcap_100${NC}"
fi
