#!/bin/bash

# Define the log file path
logfile="/var/log/rsyslog/messages-20240813.gz"

# Define an array of search patterns
patterns=(
  "FPV-WorC-FW01"
  "fplsg-centrepoint-fw01"
  "fplsg-atpfinance-fw01"
  "FGT-100E-FRASERS-DC-HA1"
  "SG46099_109668_WuX"
)

# Loop through each pattern and search in the log file
for pattern in "${patterns[@]}"; do
  echo "Searching for: $pattern"
  zcat "$logfile" | grep -iw "$pattern"
  echo -e  "\e[32m             ----------------------------------------------------------------------- \e[0m"
  echo -e  "\e[32m             ----------------------------------------------------------------------- \e[0m"
  echo -e  "\e[32m             +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ \e[0m"
  echo -e  "\e[32m             +++++++++++++++++++++++++++  Completed  +++++++++++++++++++++++++++++++ \e[0m"
  echo -e  "\e[32m             +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ \e[0m"
  echo -e  "\e[32m             ----------------------------------------------------------------------- \e[0m"
  echo -e  "\e[32m             ----------------------------------------------------------------------- \e[0m\n"
done
