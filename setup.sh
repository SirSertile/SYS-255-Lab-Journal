#!/bin/sh
sudo cp ./dhcpd.conf /etc/dhcp/dhcpd.conf
sudo yum install dhcp
sudo -i 
systemctl start dhcpd
systemctl enable dhcpd
firewall-cmd --add-service=dhcp --permanent
firewall-cmd --reload
