start="true"

while [ start = "true" ]
do
	echo -e "\nChecking Network Connexion ...\n"
	sudo dhclient;
	dhcplease=$(sudo grep dhclient /var/log/syslog | grep "DHCPACK")
	if [ $dhcplease != "" ]; then
		echo -e "\nFind Network Connexion !!!\n"
		start="false"
	else
		echo -e "\nFail Network Connexion ...\nRetrying ...\n"
	fi
done

sudo bash /script/launch.sh
