#!/bin/bash
# Written by David Serate
# Installs the MooseFS keys and repos
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
			cd /etc/mfs
			cp mfsmaster.cfg.sample mfsmaster.cfg
			cp mfsexports.cfg.sample mfsexports.cfg
			break
		;;
		c)
			yum install -y moosefs-chunkserver
			cd /etc/ mfs
			cp mfsmetalogger.cfg.sample mfsmetalogger.cfg
			break
		;;
		l)
			yum install -y moosefs-metalogger
			cd /etc/ mfs
			cp mfschunkserver.cfg.sample mfschunkserver.cfg
			cp mfshdd.cfg.sample mfshdd.cfg
			break
		;;
	esac
done