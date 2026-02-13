sudo tee /etc/php/8.3/fpm/pool.d/www.conf >/dev/null <<'EOF'
[www]
; Listen on TCP for phpMyAdmin
listen = 127.0.0.1:9000

; Define user and group
user = www-data
group = www-data

; Dynamic process manager settings
pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3

; Optional PHP settings
php_admin_value[upload_max_filesize] = 64M
php_admin_value[post_max_size] = 64M
php_admin_value[memory_limit] = 512M
php_admin_value[max_execution_time] = 300
EOF
sudo systemctl restart php8.3-fpm
sudo systemctl status php8.3-fpm
