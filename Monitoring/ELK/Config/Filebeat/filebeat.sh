# Installing from the RPM repository
cat <<EOF | sudo tee /etc/yum.repos.d/elasticsearch.repo
[elasticsearch]
name=Elasticsearch repository for 8.x packages
baseurl=https://artifacts.elastic.co/packages/8.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

yum install filebeat  -y &> /tmp/output

sudo systemctl daemon-reload
sudo systemctl enable filebeat

# Copy Config File.
cp filebeat.yml /etc/filebeat/filebeat.yml

sudo systemctl restart filebeat