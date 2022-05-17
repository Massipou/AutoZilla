cd /home/partimag

isempty=$([ "$(ls -D ./)" ] && echo "Not Empty" || echo "Empty")

if [ "$isempty" = "Not Empty" ]; then
	n=1
	for i in $(ls -d */)
	do
		value[$n]=$i
		value[$n+1]=""
		n=$n+2
	done

	FOLDER=$(whiptail --title "choose image to restore:" --menu "choose" 16 78 10 "${value[@]}" 3>&1 1>&2 2>&3 )
	exitstatus=$?
	if [ $exitstatus = 0 ]; then
		echo "folder=$FOLDER" >> /home/user/restore.cfg
		echo "restoring $FOLDER"
       		sudo bash /script/restore.sh
	fi
else
	whiptail --title "Error Message" --msgbox "There isn't save(s) in the master path of this machine model." 8 78
	sudo sudo bash /script/launch.sh

fi
