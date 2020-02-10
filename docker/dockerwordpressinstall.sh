#!/bin/bash
# Written by David
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
cd /home/david
if [ $(ls | grep docker-file -c) -eq 0 ]; then
	mkdir docker-file
fi
cd docker-file
wget https://raw.githubusercontent.com/SirSertile/SYS-255-Lab-Journal/master/docker/docker-compose.yml
docker-compose up -d
ufw allow 8000