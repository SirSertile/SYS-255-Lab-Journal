#!/bin/bash
# Written by David
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
cd /usr/local/nagios/etc
# Parsing options
function create_host(){
	host=$(host $1 | awk '{print $5}' | cut -d. -f1)
	wget -O $host.cfg https://raw.githubusercontent.com/SirSertile/SYS-255-Lab-Journal/master/nagios/ncpa_services.cfg
	sed -i "s/HOSTNAME/$host/g" ncpaservices.cfg
	sed -i "s/IPADDR/$1/g" ncpaservices.cfg
	if [ $2 = "h" ]; then
		wget -O ncpaservices.cfg https://raw.githubusercontent.com/SirSertile/SYS-255-Lab-Journal/master/nagios/ncpa_services.cfg
		sed -i "s/HOSTNAME/$host/g" ncpaservices.cfg
		cat ncpaservices.cfg >> $host.cfg
		rm ncpaservices.cfg
		echo "Config file $host.cfg created successfully with NCPA"
	else
		wget -O ncpeservices.cfg https://raw.githubusercontent.com/SirSertile/SYS-255-Lab-Journal/master/nagios/ncpe_services.cfg
		sed -i "s/HOSTNAME/$host/g" ncpeservices.cfg
		cat ncpeservices.cfg >> $host.cfg
		rm ncpeservices.cfg
		echo "Config file $host.cfg created successfully with NCPE"
	fi
}
while getopts "ch:l: " option; do
	ip=$OPTARG
	case $option in 
		c)
			# Creates and implements a directory for nagios to find config files in. 
			trailing=$(tail -n 1 nagios.cfg)
			if [ "$trailing" != "cfg_dir=/usr/local/nagios/etc/hosts" ]; then
				mkdir hosts
				echo "Updating nagios.cfg to add hosts folder. . ."
				echo "# Defining hosts folder for nagios." >> nagios.cfg
				wget -O ncpa.cfg https://raw.githubusercontent.com/SirSertile/SYS-255-Lab-Journal/master/nagios/check_ncpa.cfg
				mv ncpa.cfg hosts/ncpa.cfg
			echo "cfg_dir=/usr/local/nagios/etc/hosts" >> nagios.cfg
			fi
		;;
		h)
			# Creating a host based on IP 
			# Command to get the host from the IP 
			# Checks via ipcalc if it's actually an IP 
			if ipcalc -cs $ip; then
				cd /usr/local/nagios/etc/hosts
				create_host "$ip" "h"
				systemctl restart nagios
			else
				echo "$ip is not a valid ip"
			fi
		;;
		l)
			# Creating a host based on IP 
			# Command to get the host from the IP 
			# Checks via ipcalc if it's actually an IP 
			if ipcalc -cs $ip; then
				cd /usr/local/nagios/etc/hosts
				create_host "$ip" "l"
				systemctl restart nagios
			else
				echo "$ip is not a valid ip"
			fi
		;;
		\?)
			echo "Illegal argument $OPTARG"
		;;
	esac
done
