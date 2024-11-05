cat <<EOF | sudo tee /etc/nginx/conf.d/kibana_proxy.conf
upstream kibana {
    server 127.0.0.1:5601;
    keepalive 15;
}

server {
    listen 80;

    location / {
        proxy_pass http://kibana;
        proxy_redirect off;
        proxy_buffering off;

        proxy_http_version 1.1;
        proxy_set_header Connection "Keep-Alive";
        proxy_set_header Proxy-Connection "Keep-Alive";
    }
}
EOF

nginx -t
systemctl restart nginx