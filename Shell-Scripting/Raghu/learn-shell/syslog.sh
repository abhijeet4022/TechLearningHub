#!/bin/bash
for file in messages-*.gz; do
    echo "Processing $file..."
    zgrep -i 'FRHNVNFW01' "$file"
    zgrep -w '10.84.20.1' "$file"
done