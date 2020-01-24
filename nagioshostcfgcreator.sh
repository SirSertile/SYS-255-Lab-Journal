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
			if [ "$trailing" = "cfg_dir=/usr/local/nagios/etc/hosts" ]; then
				mkdir hosts
				echo "Updating nagios.cfg to add hosts folder. . ."
				echo "# Defining hosts folder for nagios." >> nagios.cfg
			echo "cfg_dir=/usr/local/nagios/etc/hosts" >> nagios.cfg
			fi
		;;
		h)
			# Creating a host based on IP 
			# Command to get the host from the IP 
			ip=$option
			# Checks via regex if it's actually an IP 
			if [[ $ip =~ ^(\d{1,3}.){3}\d{1,3}$ ]]; then
				hostname=$(host $ip | awk '{print $5})
				host=$($hostname | cut -d. -f1)
				printf "%s\n" \ 
				"define host {" \ 
				"	use 	generic-host" \
				"host_name	$host" \
				"alias	$hostname" \
				"address	$ip" \
				"hostgroups	allgroups" \
				"}" \
				> $host.cfg
			else
				echo "$ip is not a valid ip"
			fi
		;;
	esac
done