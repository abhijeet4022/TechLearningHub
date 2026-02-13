set -e

# \=\=\= 0) Update base OS \=\=\=
sudo apt update
sudo apt -y upgrade
sudo apt -y install curl wget gnupg2 ca-certificates lsb-release apt-transport-https unzip zip jq
sudo reboot
echo -e "127.0.0.1 test.mgt.com\n127.0.0.1 pma.mgt.com" | sudo tee -a /etc/hosts



# \=\=\= 1) Create required user/group \=\=\=
sudo groupadd clp || true
sudo useradd -m -s /bin/bash -g clp test-ssh || true

# Optional: allow sudo for setup convenience
sudo usermod -aG sudo test-ssh

# Magento web root
sudo mkdir -p /var/www/magento2
sudo chown -R test-ssh:clp /var/www/magento2

# \=\=\= 2) Install NGINX \=\=\=
sudo apt -y install nginx
sudo systemctl enable --now nginx
sudo nginx -v

# \=\=\= 3) Install PHP 8.3 (Sury) + required extensions \=\=\=
sudo install -d /etc/apt/keyrings


## Install sql by uisng scirpt MYSQL-Without-Signature.sh

mysql -u root -p
# \=\=\= 5) Create Magento DB + user \=\=\=
# Replace StrongPasswordHere! before running.
CREATE DATABASE magento DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'magentouser'@'localhost' IDENTIFIED BY 'Str@PadHere!';
GRANT ALL PRIVILEGES ON magento.* TO 'magentouser'@'localhost';
FLUSH PRIVILEGES;
SET GLOBAL log_bin_trust_function_creators = 1;
EXIT;

## Run Elastic.sh to install elasticsearch


# \=\=\= 7) Install Redis \=\=\=
sudo apt -y install redis-server
sudo sed -i 's/^\#\?supervised .*/supervised systemd/' /etc/redis/redis.conf
sudo systemctl restart redis-server
sudo systemctl enable --now redis-server
redis-cli ping

## run PHP.sh to install PHP 8.3 and extensions

# \=\=\= 8) Install Composer \=\=\=
php -r "copy('https://getcomposer.org/installer','/tmp/composer-setup.php');"
php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm -f /tmp/composer-setup.php
composer --version


# \=\=\= 9) Install Magento 2 via Composer (as test-ssh) \=\=\=
# Note: repo.magento.com requires Marketplace keys. Composer will prompt.
sudo -iu test-ssh bash -lc '
set -e
cd /var/www/magento2
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition .
'


# \=\=\= 10) Create PHP-FPM pool running as test-ssh:clp \=\=\=
# This creates a dedicated pool socket for Magento.
sudo tee /etc/php/8.3/fpm/pool.d/magento.conf >/dev/null <<EOF
[magento]
user = test-ssh
group = clp

listen = /run/php/php8.3-fpm-magento.sock
listen.owner = test-ssh
listen.group = clp
listen.mode = 0660

pm = dynamic
pm.max_children = 20
pm.start_servers = 4
pm.min_spare_servers = 2
pm.max_spare_servers = 8

php_admin_value[upload_max_filesize] = 64M
php_admin_value[post_max_size] = 64M
php_admin_value[memory_limit] = 2G
php_admin_value[max_execution_time] = 1800
EOF

sudo systemctl restart php8.3-fpm
sudo ls -l /run/php | grep magento

# \=\=\= 11) Configure NGINX to run as user test-ssh \=\=\=
# Change global NGINX user directive.
sudo sed -i.bak 's/^user .*/user test-ssh;/' /etc/nginx/nginx.conf

# \=\=\= 12) NGINX vhost for Magento (HTTP on 8080 for Varnish backend; HTTPS on 443) \=\=\=
# Uses Magento's shipped nginx.conf.sample.
sudo groupadd -f test-ssh
sudo usermod -aG test-ssh test-ssh
sudo tee /etc/nginx/sites-available/test.mgt.com >/dev/null <<'EOF'
upstream fastcgi_backend {
  server unix:/run/php/php8.3-fpm-magento.sock;
}

server {
  listen 8080;
  server_name test.mgt.com;
  set $MAGE_ROOT /var/www/magento2;
  include /var/www/magento2/nginx.conf.sample;
}
EOF
sudo ln -sf /etc/nginx/sites-available/test.mgt.com /etc/nginx/sites-enabled/test.mgt.com
sudo rm -f /etc/nginx/sites-enabled/default

sudo nginx -t
sudo systemctl restart nginx

#\=\=\= 13) Install Magento (configure Elasticsearch) \=\=\=
# Replace passwords/values before running.
sudo -iu test-ssh bash -lc '
set -e
cd /var/www/magento2

php bin/magento setup:install \
  --base-url=http://test.mgt.com/ \
  --db-host=localhost --db-name=magento --db-user=magentouser --db-password="Str@PadHere!" \
  --admin-firstname=Admin --admin-lastname=User --admin-email=admin@test.mgt.com \
  --admin-user=admin --admin-password="AdminPassword123!" \
  --backend-frontname=admin \
  --language=en_US --currency=USD --timezone=UTC --use-rewrites=1 \
  --search-engine=elasticsearch8 \
  --elasticsearch-host=127.0.0.1 --elasticsearch-port=9200

php bin/magento deploy:mode:set production
'



```text
[SUCCESS]: Magento installation complete.
[SUCCESS]: Magento Admin URI: /admin
Nothing to import.
```
# \=\=\= 14) Install Sample Data \=\=\=
sudo -iu test-ssh bash -lc '
set -e
cd /var/www/magento2
php bin/magento sampledata:deploy
php bin/magento setup:upgrade
php bin/magento indexer:reindex
php bin/magento cache:flush
'

# \=\=\= 15) Configure Magento to use Redis for cache + sessions \=\=\=
# Uses magento CLI where possible.
sudo -iu test-ssh bash -lc '
set -e
cd /var/www/magento2

php bin/magento setup:config:set --cache-backend=redis \
  --cache-backend-redis-server=127.0.0.1 \
  --cache-backend-redis-db=0 \
  --cache-backend-redis-port=6379

php bin/magento setup:config:set --session-save=redis \
  --session-save-redis-host=127.0.0.1 \
  --session-save-redis-port=6379 \
  --session-save-redis-db=1

php bin/magento cache:flush
'

## Done
# \=\=\= 16) phpMyAdmin install + NGINX site \=\=\=
apt install -y phpmyadmin php8.3-fpm php8.3-mbstring php8.3-mysql

# run setup-phpadmin-dashboard.sh to configure NGINX for phpMyAdmin on :8081
# run www-pool.sh to configure PHP-FPM pool for phpMyAdmin on :9000
# run pma.sh to configure NGINX for phpMyAdmin on :8081


# \=\=\= 17) Self-signed SSL for NGINX \=\=\=
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/mgt.key \
  -out /etc/ssl/certs/mgt.crt

sudo chmod 600 /etc/ssl/private/mgt.key


# \=\=\= 18) NGINX HTTPS server blocks + HTTP->HTTPS redirect \=\=\=
# HTTPS terminates on NGINX (443). HTTP (80) goes to Varnish, which goes to NGINX:8080.
# For simplicity: redirect 80->443 at Varnish layer later; here we keep 443 direct to NGINX.
sudo tee /etc/nginx/snippets/mgt-selfsigned.conf >/dev/null <<'EOF'
ssl_certificate /etc/ssl/certs/mgt.crt;
ssl_certificate_key /etc/ssl/private/mgt.key;
EOF

sudo tee /etc/nginx/sites-available/test.mgt.com-ssl >/dev/null <<'EOF'
upstream fastcgi_backend {
  server unix:/run/php/php8.3-fpm-magento.sock;
}

server {
  listen 443 ssl;
  server_name test.mgt.com;

  include /etc/nginx/snippets/mgt-selfsigned.conf;

  set $MAGE_ROOT /var/www/magento2;
  include /var/www/magento2/nginx.conf.sample;
}
EOF

sudo ln -sf /etc/nginx/sites-available/test.mgt.com-ssl /etc/nginx/sites-enabled/test.mgt.com-ssl

sudo nginx -t
sudo systemctl reload nginx


# \=\=\= 19) Force Magento base URLs to HTTPS \=\=\=
sudo -iu test-ssh bash -lc '
set -e
cd /var/www/magento2
php bin/magento config:set web/secure/base_url https://test.mgt.com/
php bin/magento config:set web/unsecure/base_url https://test.mgt.com/
php bin/magento config:set web/secure/use_in_frontend 1
php bin/magento config:set web/secure/use_in_adminhtml 1
php bin/magento cache:flush
'
# \=\=\= 20) Install + configure Varnish (listen :80 -> NGINX :8080) \=\=\=
sudo apt -y install varnish
sudo systemctl enable --now varnish

# Set backend to NGINX:8080
sudo tee /etc/varnish/default.vcl >/dev/null <<'EOF'
vcl 4.1;

backend default {
  .host = "127.0.0.1";
  .port = "8080";
}
EOF

# Make Varnish listen on :80
sudo sed -i.bak 's/ExecStart=.*/ExecStart=\/usr\/sbin\/varnishd -a :80 -T localhost:6082 -f \/etc\/varnish\/default.vcl -s malloc,256m/' /lib/systemd/system/varnish.service
sudo systemctl daemon-reload
sudo systemctl restart varnish

sudo ss -ltnp | egrep '(:80|:443|:8080|:8081)'

# \=\=\= 21) Configure Magento to use Varnish for Full Page Cache \=\=\=
sudo -iu test-ssh bash -lc '
set -e
cd /var/www/magento2
php bin/magento config:set system/full_page_cache/caching_application 2
php bin/magento cache:flush
'


# \=\=\= 22) Ownership requirement \=\=\=
sudo chown -R test-ssh:clp /var/www/magento2


# \=\=\= 23) Local DNS (your laptop) reminder \=\=\=
# On macOS \(/etc/hosts\) add:
# SERVER_PUBLIC_IP test.mgt.com
# SERVER_PUBLIC_IP pma.mgt.com
#
# If testing locally on the server only:
# echo "127.0.0.1 test.mgt.com pma.mgt.com" | sudo tee -a /etc/hosts
