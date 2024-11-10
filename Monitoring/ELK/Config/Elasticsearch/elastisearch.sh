# Download and install the public signing key:
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

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

yum install elasticsearch  -y &> /tmp/token

sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service


yum install kibana -y
systemctl enable kibana
systemctl restart kibana


