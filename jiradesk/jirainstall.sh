#!/bin/bash
# Written by David
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
cd /home/david
if [ $(ls | grep elk -c) -eq 0 ]; then
	mkdir elk
fi
cd elk
wget https://raw.githubusercontent.com/SirSertile/SYS-255-Lab-Journal/master/jiradesk/docker-compose.yml
docker-compose up -d
wget https://raw.githubusercontent.com/SirSertile/SYS-255-Lab-Journal/master/jiradesk/mysql.deb
docker cp mysql.deb / & sudo dpkg -i mysql.deb 
ufw allow 80