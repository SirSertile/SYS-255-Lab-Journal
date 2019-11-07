#!/bin/bash
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
yum -y update
yum -y install mariadb-server httpd epel-release yum-utils
systemctl enable mariadb
systemctl start mariadb
systemctl enable httpd
systemctl start httpd
# Stuff for PHP
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php72
yum -y install php php-common php-opcache php-mcrypt php-cli php-gd php-curl php-mysqlnd
# Pass HTTP through firewall
firewall-cmd --add-service=http --permanent
firewall-cmd --reload
echo "CREATE DATABASE wordpress CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;" | mysql -u root
echo "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password';" | mysql -u root
wget -q -O - "http://wordpress.org/latest.tar.gz" | sudo tar -xzf - -C /var/www/html --transform s/wordpress/david.com/
sudo chown root ./david.com.conf
cp ./david.com.conf /etc/httpd/conf.d/david.com.conf
sudo chown -R apache: /var/www/html/david.com
sudo systemctl restart httpd
