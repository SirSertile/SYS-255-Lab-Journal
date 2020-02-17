#!/bin/bash
# Written by David 
# Adds a public key to the repo or curls one to the repo
# Removes root ability to ssh in
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
if [ $1 -ne ]; then
	echo "Creating user $($1)"
	useradd -m -d /home/$1 -s /bin/bash $1
	mkdir /home/$1/.ssh
	cd /home/$1/.ssh
	
else
	echo "Provide an argument." 
	exit
fi 