#!/bin/bash
# Written by David
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
wget https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe3.2.1/nrpe-3.2.1.tar.gz
tar xzf nrpe-3.2.1.tar.gz
cd nrpe-nrpe-3.2.1
./configure
make all
make install-groups-users
make install
make install-config
make install-inetd
make install-init
service xinetd restart
systemctl reload xinetd
systemctl enable nrpe && systemctl start nrpe
firewall-cmd --add-port=5666 --permanent
firewall-cmd --reload