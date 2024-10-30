#!/bin/bash

# Replace the date and month as per the required details
date="22"
month="Oct"


# Don't change anything from here




# Define the output directory and file
output_dir="/mnt/syslog17logs/patchdetails"
output_file="${output_dir}/$(hostname)_${date}_${month}.csv"

# Create the output directory if it doesn't exist
if [ ! -d "$output_dir" ]; then
    mount /mnt/syslog17logs
    mkdir -p "$output_dir"
fi

echo "Package Name,Installation Date,Hostname" > "$output_file"

# Filter RPM packages installed on the specified date and format output for CSV
rpm -qa --last | awk -v host="$(hostname)" -v date="$date" -v month="$month" '
    BEGIN { OFS="," }
    $3 == date && $4 == month { print $1, $3" "$4" "$5, host }' >> "$output_file"

# Display message indicating where the CSV file is saved
echo "Output saved to $output_file"
