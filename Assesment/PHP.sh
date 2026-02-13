#!/bin/bash
set -e

echo "==============================="
echo " Installing PHP 8.3 for Magento "
echo "==============================="

# 1️⃣ Update system and install prerequisites
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y ca-certificates apt-transport-https lsb-release wget gnupg2 software-properties-common

# 2️⃣ Add Sury PHP repository
echo "Adding Sury PHP repository..."
sudo wget -qO /usr/share/keyrings/sury-php.gpg https://packages.sury.org/php/apt.gpg
echo "deb [signed-by=/usr/share/keyrings/sury-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" | \
sudo tee /etc/apt/sources.list.d/sury-php.list

# 3️⃣ Update package lists
sudo apt update

# 4️⃣ Install PHP 8.3 and recommended extensions
echo "Installing PHP 8.3 and extensions..."
sudo apt install -y php8.3 php8.3-fpm php8.3-mysql php8.3-curl php8.3-xml php8.3-gd \
php8.3-intl php8.3-mbstring php8.3-bcmath php8.3-zip php8.3-soap php8.3-cli php8.3-opcache php8.3-redis

# 5️⃣ Enable and start PHP-FPM
sudo systemctl enable --now php8.3-fpm

# 6️⃣ Set PHP 8.3 as default CLI version
sudo update-alternatives --set php /usr/bin/php8.3

# 7️⃣ Configure PHP for Magento
echo "Configuring PHP 8.3 settings..."
PHP_INI="/etc/php/8.3/fpm/php.ini"
sudo sed -i 's/^memory_limit = .*/memory_limit = 2G/' "$PHP_INI"
sudo sed -i 's/^max_execution_time = .*/max_execution_time = 1800/' "$PHP_INI"
sudo sed -i 's/^;zlib.output_compression = .*/zlib.output_compression = On/' "$PHP_INI"

# 8️⃣ Restart PHP-FPM to apply changes
sudo systemctl restart php8.3-fpm
sudo systemctl enable --now php8.3-fpm

# 9️⃣ Show PHP version and modules
echo "PHP installation completed:"
php -v
php -m

echo "==============================="
echo " PHP 8.3 Installation Done "
echo "==============================="
