#!/bin/bash
# Written by David
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
apt update -y 
apt -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Adding the new repository for docker
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update -y
# verify that the repository is added correctly and the rest of the commands
if [ $(apt-cache policy docker-ce | grep download.docker.com -c) -gt 0 ]; then
	apt install -y docker-ce 
	systemctl enable docker
	usermod -aG docker david
	apt install -y docker-compose
fi