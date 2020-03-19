#!/bin/bash
# Written by David Serate
# Auto-joins to a domain 
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
# Installs the key to trust moosefs site
curl "https://ppa.moosefs.com/RPM-GPG-KEY-MooseFS" > /etc/pki/rpm-gpg/RPM-GPG-KEY-MooseFS
# Adds the moosefs repo to the yum repos
curl "http://ppa.moosefs.com/MooseFS-3-el7.repo" > /etc/yum.repos.d/MooseFS.repo

# Parsing options for getopts to determine which packages to install 
while getopts "mcl " option; do
	case $option in
		m)
			yum install -y moosefs-master moosefs-cgi moosefs-cgiserv moosefs-cli
			break
		;;
		c)
			yum install -y moosefs-chunkserver
			break
		;;
		l)
			yum install -y moosefs-metalogger
			break
		;;
	esac
done