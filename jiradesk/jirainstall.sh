#!/bin/bash
# Written by David
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
cd /home/david
if [ $(ls | grep jira -c) -eq 0 ]; then
	mkdir jira
fi
cd jira
wget https://raw.githubusercontent.com/SirSertile/SYS-255-Lab-Journal/master/jiradesk/docker-compose.yml
docker-compose up -d
wget https://raw.githubusercontent.com/SirSertile/SYS-255-Lab-Journal/master/jiradesk/mysql.tar.gz

docker cp mysql.tar.gz jira_jira_1:/opt/atlassian/jira/lib 
docker exec tar -zxf /opt/atlassian/jira/lib/mysql.tar.gz
ufw allow 80