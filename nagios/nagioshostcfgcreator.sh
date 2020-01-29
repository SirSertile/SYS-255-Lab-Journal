#!/bin/bash
# Written by David
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
cd /usr/local/nagios/etc
# Parsing options
function create_host(){
	host=$(host $ip | awk '{print $5}' | cut -d. -f1)
	contents="define host { \n 
	\tuse 	\t generic-host \n
	\thost_name	\t $host \n 
	\talias	\t $host \n		
	\taddress	\t $ip \n 
	\tmax_check_attempts \t 2 \n 
	\tfirst_notification_delay \t 0 \n 
	\tcheck_interval \t 1 \n 
	\tactive_checks_enabled \t 1 \n 
	\tcheck_command \t check-host-alive \n 
	}"
	echo -e $contents > $host.cfg
}
function create_ncpa(){
	wget -O ncpaservices.cfg https://raw.githubusercontent.com/SirSertile/SYS-255-Lab-Journal/master/nagios/ncpa_services.cfg
	sed -i "s/HOSTNAME/$host/g" ncpaservices.cfg
	cat ncpaservices.cfg >> $host.cfg
	rm ncpaservices.cfg
	echo "Config file $host.cfg created successfully with NCPA"
}
function create_ncpe(){
	wget -O ncpeservices.cfg https://raw.githubusercontent.com/SirSertile/SYS-255-Lab-Journal/master/nagios/ncpe_services.cfg
	sed -i "s/HOSTNAME/$host/g" ncpeservices.cfg
	cat ncpeservices.cfg >> $host.cfg
	rm ncpeservices.cfg
	echo "Config file $host.cfg created successfully with NCPA"
}
while getopts "chl: " option; do
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
			ip=$OPTARG
			# Checks via regex if it's actually an IP 
			if ipcalc -cs $ip; then
				cd /usr/local/nagios/etc/hosts
				create_host
				create_ncpa
				systemctl restart nagios
			else
				echo "$ip is not a valid ip"
			fi
		;;
		l)
			ip=$OPTARG
			# Checks via regex if it's actually an IP 
			if ipcalc -cs $ip; then
				cd /usr/local/nagios/etc/hosts
				create_host
				create_ncpe
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