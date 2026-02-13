sudo tee /etc/nginx/sites-available/pma.mgt.com >/dev/null <<'EOF'
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
        fastcgi_pass 127.0.0.1:9000;
    }

    location ~* \.(?:css|js|jpg|jpeg|gif|png|ico|svg|woff2?)$ {
        expires max;
        log_not_found off;
    }
}
EOF
systemctl restart nginx