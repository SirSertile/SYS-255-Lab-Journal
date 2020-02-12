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
wget https://raw.githubusercontent.com/SirSertile/SYS-255-Lab-Journal/master/jiradesk/mysql.jar
wget https://raw.githubusercontent.com/SirSertile/SYS-255-Lab-Journal/master/jiradesk/my.cnf
docker cp mysql.jar jira_jira_1:/opt/atlassian/jira/lib 
docker exec jira_jira_1 mv /opt/atlassian/jira/lib/mysql.jar /opt/atlassian/jira/lib/mysql-connector-java-8.0.19.jar
docker restart jira_jira_1 
ufw allow 80