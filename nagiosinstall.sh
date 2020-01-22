#!/bin/bash
# Written by David
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
yum -y install gcc glibc glibc-common wget unzip httpd php gd gd-devel perl postfix 
if (( $? == 0 )); then
	cd /tmp
	wget https://raw.githubusercontent.com/SirSertile/SYS-255-Lab-Journal/master/nagios-4.4.5.tar.gz
	tar xzf nagioscore.tar.gz
	cd nagioscore-nagios-4.4.5
	./configure
	make all
	make install-groups-users
	usermod -a -G nagios apache
	make install
	make install-daemoninit
	systemctl enable httpd.service
else
	echo "Dependencies unmet or other yummy errors encountered"
fi 
