cd /home/partimag
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
