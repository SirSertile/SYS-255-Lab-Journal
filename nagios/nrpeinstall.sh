#!/bin/bash
# Written by David
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
yum -y install xinetd install gcc glibc glibc-common 
if (( $? == 0 )); then
	wget -O nrpe.tar.gz https://github.com/SirSertile/SYS-255-Lab-Journal/blob/master/nagios/nrpe-4.0.0.tar.gz?raw=true
	tar xzf nrpe.tar.gz
	cd nrpe-4.0.0
	./configure --enable-command-args --enable-ssl
	make check_nrpe
	#make install-plugin
	firewall-cmd --add-port=5666/tcp --permanent
	firewall-cmd --reload
fi