#!/bin/bash

# Update yum
yum update -y
 
# Install packages
yum install -y php71 php71-cli php71-fpm php71-mysql php71-xml php71-curl php71-opcache php71-pdo php71-gd php71-pecl-apcu php71-mbstring php71-imap php71-pecl-redis php71-mcrypt php71-mysqlnd
yum install -y httpd24
yum install -y mysql mysql-server
yum install -y curl
yum install -y git
 
# Setup apache to start on boot
chkconfig httpd on
 
# Composer
curl -Ss https://getcomposer.org/installer | php
mv composer.phar /usr/bin/composer
 
# Allow URL rewrites
sed -i 's#AllowOverride None#AllowOverride All#' /etc/httpd/conf/httpd.conf
 
# Change apache document root
sed -i 's#DocumentRoot "/var/www/html"#DocumentRoot "/var/www/html/public"#' /etc/httpd/conf/httpd.conf
 
# Boot apache
service httpd start
 
# Boot MySQL
service mysqld start
 
# Create database
mysql -u root -e "CREATE DATABASE database;"
 
# Create database user
mysql -u root -e "CREATE USER 'example'@'localhost' IDENTIFIED BY 'password';" -p
 
# Finish making MySQL external accessible for the example user
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'example'@'localhost';" -p
 
# Clone reposity
git clone https://github.com/laravel/framework.git /var/www/html
 
# Create cache and chmod folders
mkdir -p /var/www/html/bootstrap/cache
chmod 777 -R /var/www/html/bootstrap/cache
chmod 777 -R /var/www/html/storage
 
# Run Composer
cd /var/www/html && composer install --no-dev
 
# Configure Env
cp /var/www/html/.env.example /var/www/html/.env
 
# Configure Application Key
php artisan key:generate
 
# Migrate all tables
php artisan migrate
 
# Bring up application
php artisan up