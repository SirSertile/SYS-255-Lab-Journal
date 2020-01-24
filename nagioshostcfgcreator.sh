#!/bin/bash
# Written by David
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
cd /usr/local/nagios/etc
# Parsing options
while getopts "ch: " option; do
	case $option in 
		c)
			# Creates and implements a directory for nagios to find config files in. 
			trailing=$(tail -n 1 nagios.cfg)
			if [ "$trailing" != "cfg_dir=/usr/local/nagios/etc/hosts" ]; then
				mkdir hosts
				echo "Updating nagios.cfg to add hosts folder. . ."
				echo "# Defining hosts folder for nagios." >> nagios.cfg
			echo "cfg_dir=/usr/local/nagios/etc/hosts" >> nagios.cfg
			fi
		;;
		h)
			# Creating a host based on IP 
			# Command to get the host from the IP 
			ip=$OPTARG
			# Checks via regex if it's actually an IP 
			if ipcalc -cs $ip; then
				host=$(host $ip | awk '{print $5}' | cut -d. -f1)
				contents="define host {
				\tuse 	\t generic-host
				\thost_name	\t $host
				\talias	\t $host				
				\taddress	\t $ip
				\tmax_check_attempts \t 2
				\tfirst_notification_delay \t 0
				\tcheck_interval \t 1
				}"
				echo -e $contents > $host.cfg
				echo "Config file $host.cfg created successfully" 
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
