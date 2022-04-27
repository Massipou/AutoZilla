disk=()
size=()
name=()
n=1

. restore.cfg

while IFS= read -r -d $'\0' device; do
    device=${device/\/dev\//}
    disk+=($device)
    name+=("`cat "/sys/class/block/$device/device/model"`")
    size+=("`cat "/sys/class/block/$device/size"`")
done < <(find "/dev/" -regex '/dev/sd[a-z]\|/dev/vd[a-z]\|/dev/hd[a-z]\|/dev/nvme[0-9]n[1-9]' -print0)

for i in `seq 0 $((${#disk[@]}-1))`; do
	echo -e "${disk[$i]}\t${name[$i]}\t${size[$i]}"
	bsize=${size[$i]}
	gsize=$((bsize / 2000000))

	list[$n]="${disk[$i]}"
	list[$n+1]="${name[$i]} ${gsize}Gb"
	n=$n+2
done

DISK=$(whiptail --title "Choisissez le disque de destination pour $model:" --menu "choose" 16 78 10 "${list[@]}" 3>&1 1>&2 2>&3 )
exitstatus=$?
if [ $exitstatus = 0 ]; then
        echo "User selected Ok and entered " $DISK
        echo "disk=$DISK" >> restore.cfg
        sudo bash /script/save_or_restore.sh $DISK
else
	bash /script/launch.sh
fi
