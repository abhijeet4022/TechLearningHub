#!/bin/bash
# Script to configure phpMyAdmin on Nginx

CONFIG_FILE="/etc/nginx/sites-available/pma.mgt.com"

echo "Creating Nginx configuration for phpMyAdmin..."

sudo tee $CONFIG_FILE >/dev/null <<'EOF'
server {
    listen 8081;
    server_name pma.mgt.com;

    root /usr/share/phpmyadmin;
    index index.php index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    }

    location ~* \.(?:css|js|jpg|jpeg|gif|png|ico|svg|woff2?)$ {
        expires max;
        log_not_found off;
    }
}
EOF

echo "Enabling site..."
sudo ln -sf /etc/nginx/sites-available/pma.mgt.com /etc/nginx/sites-enabled/

echo "Testing Nginx configuration..."
sudo nginx -t

echo "Reloading Nginx..."
sudo systemctl reload nginx

echo "phpMyAdmin should now be accessible at http://pma.mgt.com:8081"
