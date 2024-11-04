#!/bin/bash
###############
#e-Com Project#
#Author: Mozka#
###############

set -e

source func.sh

# Install LAMP stack
for package in $(cat packages.txt); do
  install_package $package
done

# Configure firewalld
start_service firewalld
firewall-cmd --permanent --zone=public --add-port=3306/tcp
firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --reload

# Configure mariadb database
start_service mariadb
mysql <db-load-script.sql

# Configure httpd
sed -i 's/index.html/index.php/g' /etc/httpd/conf/httpd.conf
start_service httpd

# Clone e-commerce repository into web server
git clone https://github.com/kodekloudhub/learning-app-ecommerce.git /var/www/html/
