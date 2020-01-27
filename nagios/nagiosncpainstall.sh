#!/bin/bash
# Written by David
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
cd /tmp
wget https://assets.nagios.com/downloads/ncpa/check_ncpa.tar.gz
tar xvf check_ncpa.tar.gz
chown nagios:nagios check_ncpa.py
chmod 775 check_ncpa.py
mv check_ncpa.py /usr/local/nagios/libexec