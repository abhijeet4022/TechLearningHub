#!/bin/bash
cd /var/log/rsyslog
if [ $? -ne 0 ]; then
  echo "Directory not exist"
  exit 1
fi

for file in messages-*.gz; do
    echo "Processing $file..."
    zgrep -i 'FRHNVNFW01' "$file"
    zgrep -w '10.84.20.1' "$file"
done