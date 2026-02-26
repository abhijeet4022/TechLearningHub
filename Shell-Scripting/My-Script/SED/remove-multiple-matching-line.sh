```bash
#!/bin/bash
PROD_DIR="/Users/abhijeet.pramanik/Library/CloudStorage/OneDrive-AutomationAnywhere/WorkSpace/Notepad/DA-Proxy/GPT-5.1/Prod"

find "$PROD_DIR" -type f -exec sed -i '' \
  -e '12{/^ref+awsssm:/d;}' \
  -e '31{/^ref+awsssm:/d;}' \
  -e '53{/^ref+awsssm:/d;}' \
  -e '72{/^ref+awsssm:/d;}' {} +
```

```bash
find "$PROD_DIR" -type f -exec sed -i '.bak' \
  -e '12{/^ref+awsssm:/d;}' \
  -e '31{/^ref+awsssm:/d;}' \
  -e '53{/^ref+awsssm:/d;}' \
  -e '72{/^ref+awsssm:/d;}' {} +
```
