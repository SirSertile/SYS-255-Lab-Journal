#!/bin/bash
# Written by David
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
yum -y install xinetd install gcc glibc glibc-common libssl-devel
while getopts "i: " option; do
	ip=$OPTARG
	case $option in 
		i)
			if ipcalc -cs $ip; then
				if (( $? == 0 )); then
					wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
					tar zxf nagios-plugins.tar.gz
					cd ./nagios-plugins-release-2.2.1/
					./tools/setup
					./configure
					make
					make install
					make install-groups-users
					wget -O nrpe.tar.gz https://github.com/SirSertile/SYS-255-Lab-Journal/blob/master/nagios/nrpe-4.0.0.tar.gz?raw=true
					tar xzf nrpe.tar.gz
					cd nrpe-4.0.0
					./configure
					make
					make all
					make install-config
					make install-inetd
					make install-init 
					firewall-cmd --add-port=5666/tcp --permanent
					firewall-cmd --reload
					sed -i "s/127.0.0.1 ::1/$ip/g" /etc/xinetd.d/nrpe
					sed -i "s/disable *= yes/disable\t= no/g" /etc/xinetd.d/nrpe
					sed -i "s/allowed_hosts=127.0.0.1,::1/allowed_hosts=127.0.0.1,::1,$ip/g" /usr/local/nagios/etc/nrpe.cfg
					systemctl enable xinetd && systemctl restart xinetd
					systemctl enable nrpe && systemctl restart nrpe
					# echo -e "nrpe \t 5666/tcp \t # NRPE" | tee -a /etc/services
				fi
			else
				echo "$ip is not a valid ip"
			fi
		;;
		\?)
			echo "Illegal argument $OPTARG"
		;;
	esac
done
