#!/bin/bash
###############
#e-Com Project#
#Author: Mozka#
###############

set -e

source func.sh

# Install LAMP stack
echo "------------------ Installing LAMP Stack ------------------"

for package in $(cat packages.txt); do
  print_color "green" "Installing $package.. "
  install_package $package
done

# Configure firewalld
echo "------------------ Setup Firewall ------------------"

print_color "green" "Starting FirewallD.."
start_service firewalld
print_color "green" "Configuring FirewallD rules for database and web server"
sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --reload

print_color "green" "---------------- Setup FirewallD - Finished ------------------"

# Configure mariadb database
echo "------------------ Setup Database Server ------------------"

print_color "green" "Starting MariaDB Server.."
start_service mariadb
sudo mysql <db-load-script.sql

print_color "green" "---------------- Setup Database Server - Finished ------------------"

# Configure httpd
echo "------------------ Configuring Web Server ------------------"

print_color "green" "Configuring httpd configuration file.."
sudo sed -i 's/index.html/index.php/g' /etc/httpd/conf/httpd.conf
print_color "green" "Starting HTTPD.."
start_service httpd

print_color "green" "---------------- Setup Web Server - Finished ------------------"

# Clone e-commerce repository into web server
sudo git clone https://github.com/kodekloudhub/learning-appsudo sed -i 's#// \(.*mysqli_connect.*\)#\1#' /var/www/html/index.php
sudo sed -i 's#// \(\$link = mysqli_connect(.*172\.20\.1\.101.*\)#\1#; s#^\(\s*\)\(\$link = mysqli_connect(\$dbHost, \$dbUser, \$dbPassword, \$dbName);\)#\1// \2#' /var/www/html/index.php-ecommerce.git /var/print_color "green" "Updating index.php.."
sudo sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.phpwww/html/
