#!/bin/bash
# Written by David
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
yum -y install xinetd install gcc glibc glibc-common 
if (( $? == 0 )); then
	wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
	tar zxf nagios-plugins.tar.gz
	cd ./nagios-plugins-release-2.2.1/
	./tools/setup
	./configure
	make
	make install
	make install-groups-users
	make install-config
	make install-inetd
	make install-init 
	wget -O nrpe.tar.gz https://github.com/SirSertile/SYS-255-Lab-Journal/blob/master/nagios/nrpe-4.0.0.tar.gz?raw=true
	tar xzf nrpe.tar.gz
	cd nrpe-4.0.0
	./configure
	make all
	systemctl enable xinetd && systemctl restart xinetd
	systemctl enable nrpe && systemctl restart nrpe
	firewall-cmd --add-port=5666/tcp --permanent
	firewall-cmd --reload
fi