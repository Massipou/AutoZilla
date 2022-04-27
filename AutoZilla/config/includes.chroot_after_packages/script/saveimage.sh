. /home/user/restore.cfg

modelname=$(echo "$model" | sed 's/ /_/g' | sed 's/,/_/g' | sed 's/+//g' | sed 's/*//g')
echo "/usr/sbin/ocs-sr -q2 -c -j2 -z1p -i 4096 -sfsck -senc -p choose savedisk $date'_'$modelname $disk"


#sudo /usr/sbin/ocs-sr -q2 -c -j2 -z1p -i 4096 -sfsck -senc -p choose savedisk $date'_'$modelname $disk
sudo /usr/sbin/ocs-sr -q2 -j2 -z1p -i 4096 -sfsck -senc -p choose savedisk $date'_'$modelname $disk
