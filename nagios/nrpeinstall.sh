#!/bin/bash
# Written by David
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
yum install xinetd
if (( $? == 0 )); then
	wget https://raw.githubusercontent.com/SirSertile/SYS-255-Lab-Journal/blob/master/nagios/nrpe-4.0.0.tar.gz
	tar xzf nrpe-4.0.0.tar.gz
	cd nrpe-nrpe-4.0.0
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
fi