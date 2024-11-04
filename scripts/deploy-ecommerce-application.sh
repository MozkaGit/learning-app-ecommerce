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
firewall-cmd --permanent --zone=public --add-port=3306/tcp
firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --reload

print_color "green" "---------------- Setup FirewallD - Finished ------------------"

# Configure mariadb database
echo "------------------ Setup Database Server ------------------"

print_color "green" "Starting MariaDB Server.."
start_service mariadb
mysql <db-load-script.sql
cat >/var/www/html/.env <<-EOF
DB_HOST=localhost
DB_USER=ecomuser
DB_PASSWORD=ecompassword
DB_NAME=ecomdb
EOF

print_color "green" "---------------- Setup Database Server - Finished ------------------"

# Configure httpd
echo "------------------ Configuring Web Server ------------------"

print_color "green" "Configuring httpd configuration file.."
sed -i 's/index.html/index.php/g' /etc/httpd/conf/httpd.conf
mv .env /var/www/html/
print_color "green" "Starting HTTPD.."
start_service httpd

print_color "green" "---------------- Setup Web Server - Finished ------------------"

# Clone e-commerce repository into web server
git clone https://github.com/kodekloudhub/learning-app-ecommerce.git /var/www/html/
