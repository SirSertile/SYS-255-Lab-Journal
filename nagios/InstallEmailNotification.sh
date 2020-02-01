#!/bin/bash
# Written by David
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi

yum install -y ssmtp

wget https://raw.githubusercontent.com/SirSertile/SYS-255-Lab-Journal/master/nagios/email.cfg

# add contact.cfg to define a location for where the emails are sent 
cd /usr/local/nagios/etc/
wget -O contactsnew.cfg https://raw.githubusercontent.com/SirSertile/SYS-255-Lab-Journal/master/nagios/contact.cfg
cat contactsnew.cfg >> contacts.cfg

echo "You still need to set up SSMTP settings in /etc/ssmtp/ssmtp.conf" 