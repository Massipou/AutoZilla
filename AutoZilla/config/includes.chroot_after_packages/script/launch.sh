sudo mkdir /mnt/smb/
sudo mkdir /mnt/smb/Utils/
sudo mkdir /home/partimag/
sudo mkdir /mnt/usb

sudo umount /home/partimag/

sudo touch /script/logs.txt



cp /lib/live/mount/medium/preconfig.cfg .
. preconfig.cfg

echo -e "\n Trying connection to share IP \n"

ping -c 1 $shareip
if [ $? -ne 0 ]; then
	echo -e "\n Failed. \n"
	sudo bash /etc/profile.d/launcher.sh
fi

echo "done" >> /script/logs.txt

echo "mappinng NAS UTILS ..." >> /script/logs.txt
#sudo mount -t cifs //10.0.1.2/Utils /mnt/smb/Utils/ -o username=guest,password=""
mount -t cifs $db_share /mnt/smb/Utils/ -o username=$db_username,password=$db_password

echo "done" >> /script/logs.txt

echo "Get machine model name ..." >> /script/logs.txt
model=$(sudo dmidecode -t1 |grep "Product Name:"|sed 's/\tProduct Name: //g')
echo "model=\"$model\"" > restore.cfg
echo "machine name: $model" >> /script/logs.txt

echo "get path ... " >> /script/logs.txt

path=$(cat /mnt/smb/Utils$db_path|grep "$model;"|sed 's/.*;//g'|sed 's/\r//g')
echo "path=\"$path\"" >> restore.cfg
echo "path=$path" >> /script/logs.txt
if [ $path = ]
then
	echo "/!\\ there is no path for $model in path.txt /!\\" >> /script/logs.txt
	whiptail --title "Error Message" --msgbox "there is no path for \"$model\" in path.txt" 8 78
	sudo bash /script/launch.sh
else
	echo "path = $path" >> /script/logs.txt
	echo "mounting clonezilla files:" >> /script/logs.txt
	echo "CIFS MOUNT OPTIONS: //$shareip$path /home/partimag -o username=guest,password=" >> /script/logs.txt
	#sudo mount -t cifs //10.0.1.2$path /home/partimag -o username=guest,password=""
	sudo mount -t cifs "//$shareip$path" /home/partimag -o username=guest,password=""
	echo "done" >> /script/logs.txt
	echo "launch choose disk:" >> /script/logs.txt
	sudo bash /script/choosedisk.sh
fi
