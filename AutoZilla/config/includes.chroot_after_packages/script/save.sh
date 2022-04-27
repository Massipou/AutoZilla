sudo umount /home/partimag

#model=$(sudo dmidecode -t1 |grep "Product Name:"|sed 's/\tProduct Name: //g')
#path=$(cat /mnt/smb/Utils/path.txt|grep "$model"|sed 's/.*;//g')
date=$(date +"%d-%m-%Y")

. /home/user/restore.cfg
. /home/user/preconfig.cfg

echo "date=$date" >> restore.cfg

#DEMANDE DU CHEMIN OU SAUVEGARDER LE DISQUE
savepath=$(whiptail --title "Chemin de sauvegarde pour $model" --inputbox "Quel est le chemin de sauvegarde ?" 10 60 $path 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
	#DEMANDE LE NOM DU DOSSIER OU STOCKER L'IMAGE
	savefolder=$(whiptail --title "dossier de la sauvegarde" --inputbox "Entrez le nom de la sauvegarde" 10 60 $date 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [ $exitstatus = 0 ]; then
		username=$(whiptail --title "Login" --inputbox "samba share username :" 10 60 "" 3>&1 1>&2 2>&3)
		exitstatus=$?
                if [ $exitstatus = 0 ]; then
			password=$(whiptail --title "Password" --inputbox "Password:" 10 60 "" 3>&1 1>&2 2>&3)
			exitstatus=$?
			if [ $exitstatus = 0 ]; then
				#MONTAGE DU NAS EN ECRITURE.
				echo "mounting share ..."
				sudo mount -t cifs //$shareip$savepath /home/partimag -o username=$username,password=$password
				if [ $exitstatus = 0 ]; then
					echo "success"
					echo "create save folder"
	                                mkdir /home/partimag/$savefolder
					exitstatus=$?
					if [ $exitstatus = 0 ]; then
						echo "unmount share"
						sudo umount /home/partimag
						echo "remount share in the save folder"
						echo "10.0.1.2$savepath/$savefolder /home/partimag -o username=$username,password=$password"
						sudo mount -t cifs //$shareip$savepath/$savefolder /home/partimag -o username=$username,password=$password
						exitstatus=$?
                                        	if [ $exitstatus = 0 ]; then
							echo "done"
							echo "launching save script ..."
							sudo bash /script/saveimage.sh
						else
							whiptail --title "Error Message" --msgbox "failed to remount filesystem" 8 78
							echo "failed to remount filesystem"
						fi
					else
						whiptail --title "Error Message" --msgbox "fail to create save directory" 8 78
						echo "fail to create save directory "
					fi
				else
					whiptail --title "Error Message" --msgbox "fail to mount smb share" 8 78
					echo "fail to mount smb share"
				fi
			fi
		fi
	fi
fi

sudo bash /script/launch.sh
