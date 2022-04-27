OPTION=$(whiptail --title "RESTORE or SAVE" --menu "Choisissez si vous voulez restaurer une sauvegarde ou sauvegarder un disque:" 15 60 4 \
"1" "RESTORE" \
"2" "SAVE" 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
	echo "Vous avez choisi $OPTION"
	if [ $OPTION = 1 ]; then
		sudo bash /script/folderbrowse.sh
	else
		sudo bash /script/save.sh
	fi
else
	echo "vous avez annulé"
	sudo bash /script/save.sh
fi
