#!/bin/bash
# Written by Henry and David
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi

#installation of basic systemrecs
#yum install -y libio-socket-ssl-perl libnet-ssleay-perl perl
yum install -y perl-IO-Socket-SSL perl perl-Net-SSLeay
yum install -y 'perl(Net::SSLeay)' 'perl(IO::Socket::SSL)'

wget http://caspian.dotconf.net/menu/Software/SendEmail/sendEmail-v1.56.tar.gz

tar -zxvf sendEmail-v1.56.tar.gz

#copy and send it to bin
sudo cp -a sendEmail-v1.56/sendEmail /usr/local/bin
# why is this here? 
# perl /usr/local/bin/sendEmail

# add resources2.cfg, and adds it to the nagios config file 
cd /usr/local/nagios/etc/
wget https://raw.githubusercontent.com/SirSertile/master/nagios/resources2.cfg
sed '/resource_file=/usr/local/nagios/etc/resources.cfg/a resource_file=/usr/local/nagios/etc/resources2.cfg' /usr/local/nagios/etc/nagios.cfg

# add contact.cfg to define a location for where the emails are sent 
cd /usr/local/nagios/etc/hosts/
wget https://raw.githubusercontent.com/SirSertile/master/nagios/contact.cfg


cp commands.cfg commands.cfg.old
