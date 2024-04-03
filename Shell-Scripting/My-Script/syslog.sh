#!/bin/bash
if [ -d /var/log/rsyslog ]; then
  echo "changing the directory."
  cd /var/log/rsyslog
else
  echo "Directory not exist"
  exit 1
fi

for file in messages-*.gz; do
    echo "Processing $file..."
    zgrep -i 'FRHNVNFW01' "$file"
    zgrep -w '10.84.20.1' "$file"
done