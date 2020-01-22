#!/bin/bash
# Written by David
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
# Installing prereq packages
yum -y gcc glibc glibc-common make gettext automake autoconf wget openssl-devel net-snmp net-snmp-utils epel-release
yum install -y perl-Net-SNMP
if (( $? == 0 )); then
	cd /tmp
	wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
	tar zxf nagios-plugins.tar.gz
	cd /tmp/nagios-plugins-release-2.2.1/
	./tools/setup
	./configure
	make
	make install
else
	echo "Dependencies unmet or other yummy errors encountered"
fi 