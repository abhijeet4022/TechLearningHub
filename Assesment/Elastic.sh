# \=\=\= 6) Install Elasticsearch 8 (as requested) \=\=\=
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /etc/apt/keyrings/elasticsearch.gpg
echo "deb [signed-by=/etc/apt/keyrings/elasticsearch.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list >/dev/null

sudo apt update
sudo apt -y install elasticsearch

# Bind ES to localhost only
sudo sed -i 's/^\#\?network.host:.*/network.host: 127.0.0.1/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/^\#\?http.port:.*/http.port: 9200/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/^\#\?xpack.security.enabled:.*/xpack.security.enabled: false/' /etc/elasticsearch/elasticsearch.yml

sudo systemctl daemon-reload
sudo systemctl restart elasticsearch
sudo systemctl enable --now elasticsearch

curl -s http://127.0.0.1:9200 | head -n 5