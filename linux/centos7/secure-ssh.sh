#!/bin/bash
# Written by David 
# Adds a public key to the repo or curls one to the repo
# Removes root ability to ssh in
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
if [ ! -z "$1" ]; then
	echo "Creating user $1"
	useradd -m -d /home/$1 -s /bin/bash $1
	mkdir /home/$1/.ssh
	cd /home/$1/.ssh
	wget -O authorized_keys https://raw.githubusercontent.com/SirSertile/SYS-255-Lab-Journal/master/linux/keys/id_rsa.pub
	chmod 700 /home/$1/.ssh
	chmod 600 /home/$1/.ssh/authorized_keys
	chown -R $1:$1 /home/$1/
	sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
else
	echo "Provide an argument." 
	exit
fi 