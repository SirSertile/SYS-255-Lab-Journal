#!/bin/bash
# Written by David
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
yum install xinetd -y
if (( $? == 0 )); then
	wget -O nrpe.tar.gz https://github.com/SirSertile/SYS-255-Lab-Journal/blob/master/nagios/nrpe-4.0.0.tar.gz?raw=true
	tar xzf nrpe.tar.gz
	cd nrpe-4.0.0
	./configure
	make check_nrpe
	make install-plugin
fi