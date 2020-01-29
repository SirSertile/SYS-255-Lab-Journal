#!/bin/bash
# Written by David
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
yum install xinetd -y
if (( $? == 0 )); then
	wget https://raw.githubusercontent.com/SirSertile/SYS-255-Lab-Journal/blob/master/nagios/nrpe-4.0.0.tar.gz
	tar xzf nrpe-4.0.0.tar.gz
	cd nrpe-4.0.0
	./configure
	make all
	make install-groups-users
	make install
	make install-config
	make install-inetd
	make install-init 
	systemctl enable xinetd && systemctl restart xinetd
	systemctl enable nrpe && systemctl restart nrpe
	firewall-cmd --add-port=5666/tcp --permanent
	firewall-cmd --reload
fi