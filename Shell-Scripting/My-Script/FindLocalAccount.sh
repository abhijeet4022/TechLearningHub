#!/bin/bash

# Get the hostname
hostname=$(hostname)
# Define the output file
output_file="/mnt/syslog17logs/localaccount/$(hostname)_local_account.csv"

# Add header to CSV
echo "Username,UID,GID,Shell,Hostname" > "$output_file"

# Find local accounts with UID >= 1000 and shell set to /bin/bash, and save to CSV file
awk -F: -v host="$hostname" '$3 >= 1000 && $7 == "/bin/bash" {print $1 "," $3 "," $4 "," $7 "," host}' /etc/passwd >> "$output_file"

# Notify the user about the output file location
echo "Results saved to $output_file"


