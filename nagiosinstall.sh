  
#!/bin/bash
# Written by David
if (( $EUID != 0 )); then 
	echo "Run with sudo privileges"
	exit
fi
yum -y install gcc glibc glibc-common wget unzip httpd php gd gd-devel perl postfix 
if (( $? == 0 )); then
	cd /tmp
	wget -O nagioscore.tar.gz https://raw.githubusercontent.com/SirSertile/SYS-255-Lab-Journal/master/nagios-4.4.5.tar.gz
	tar xzf nagioscore.tar.gz
	cd nagios-4.4.5
	./configure
	make all
	make install-groups-users
	usermod -a -G nagios apache
	make install
	make install-daemoninit
	# configs for the web interface
	systemctl enable httpd.service
	firewall-cmd --add-service=http --permanent
	firewall-cmd --reload
	systemctl restart httpd.service
	make install-commandmode
	# Installs sample configs to 
	make install-config
	# Installs configs for Apache
	make install-webconf
	# Installs the init script in /lib/systemd/system
	make install-init 
	systemctl restart nagios.service
	htpasswd -c -b /usr/local/nagios/etc/htpasswd.users nagiosadmin admin
	echo "Sets the default nagiosadmin password to admin. CHANGE THIS ON YOUR OWN."
	echo "Navigate to (server's IP)/nagios and enter the default password and admin"
	chmod -R +rwx /usr/local/nagios/var/rw/ 
	sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
	setenforce Permissive
else
	echo "Dependencies unmet or other yummy errors encountered"
fi 