# 1️⃣ Remove any old MySQL repo files
sudo rm -f /etc/apt/sources.list.d/mysql.list
sudo rm -f /etc/apt/sources.list.d/mysql-*.list
sudo rm -f /etc/apt/sources.list.d/mysql.sources
sudo rm -f /etc/apt/sources.list.d/mysql-tools.sources
sudo rm -f /usr/share/keyrings/mysql*.gpg

# 2️⃣ Add MySQL 8.0 repo with "trusted=yes" to bypass signature
echo "deb [trusted=yes] http://repo.mysql.com/apt/debian bookworm mysql-8.0" | \
sudo tee /etc/apt/sources.list.d/mysql.list

# 3️⃣ Update package list
sudo apt update

# 4️⃣ Install MySQL
sudo apt install -y mysql-community-server

# 5️⃣ Enable and start MySQL
sudo systemctl enable --now mysql
sudo sed -i '/^\[mysqld\]/a log_bin_trust_function_creators = 1' /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql
systemctl enable mysql
# 6️⃣ Check MySQL version
mysql --version
