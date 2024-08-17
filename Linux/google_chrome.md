# Install google chrome.

* Set the Repository.
```
cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF
```

* Install Google Chrome.
`dnf install google-chrome-stable`

* Open Google Chrome
`google-chrome --no-sandbox --user-data-dir`

* Follow the below
* `vim /opt/google/chrome/google-chrome` and replace `exec -a "$0" "$HERE/chrome" "$@"` to `exec -a "$0" "$HERE/chrome" "$@" --user-data-dir --no-sandbox`