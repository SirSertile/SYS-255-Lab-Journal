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

cd /usr/local/nagios/etc/objects

wget http://caspian.dotconf.net/menu/Software/SendEmail/sendEmail-v1.56.tar.gz

tar -zxvf sendEmail-v1.56.tar.gz

#copy and send it to bin
sudo cp -a sendEmail-v1.56/sendEmail /usr/local/bin
# why is this here? 
perl /usr/local/bin/sendEmail

echo '$USER5$=david.serate@mymail.champlain.edu' >> /usr/local/nagios/etc/resource.cfg
echo '$USER7$=smtp.gmail.com:587' >> /usr/local/nagios/etc/resource.cfg
echo '$USER9$=email' >> /usr/local/nagios/etc/resource.cfg
echo '$USER10$=password' >> /usr/local/nagios/etc/resource.cfg

cd /usr/local/nagios/etc/objects/

cp commands.cfg commands.cfg.old
