sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install fontconfig java-17-openjdk -y
sudo yum install jenkins -y
cp jenkins.service  /usr/lib/systemd/system/jenkins.service
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl restart jenkins