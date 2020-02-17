#!/bin/bash
# Written by David 
# Adds a public key to the repo or curls one to the repo
# Removes root ability to ssh in
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
if [ $1 -z ]; then
	echo "Creating user $($1)"
	useradd -m -d /home/$1 -s /bin/bash $1
	mkdir /home/$1/.ssh
	mkdir /home/$1/.ssh/authorized_keys
	cd /home/$1/.ssh/authorized_keys
	wget https://raw.githubusercontent.com/SirSertile/SYS-255-Lab-Journal/master/linux/keys/id_rsa.pub
	chmod 700 /home/$1/.ssh
	chmod 600 /home/$1/.ssh/authorized_keys
	chown -R $1:$1 /home/$1/
	
else
	echo "Provide an argument." 
	exit
fi 