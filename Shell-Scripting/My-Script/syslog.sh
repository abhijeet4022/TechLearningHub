#!/bin/bash
if [ -d /var/log/rsyslog ]; then
  echo "Changing the directory to syslog."
  cd /var/log/rsyslog
else
  echo "Directory not exist"
  exit 1
fi

#for file in messages-*.gz; do
for file in messages*; do
    echo -e "\n\e[32mChecking on $file file.\e[0m"
    zgrep -i 'FRHNVNFW01' "$file"
    zgrep -w '10.84.20.1' "$file"
done


