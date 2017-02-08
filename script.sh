#!/bin/bash

clear
cwd=$(pwd)
currenthomedir=$homedirct$whoamiforeal
whoamif='whoami'
homedirct="/home/"
fsl=/
cmd_ls="ls"
usrdir=~
spacr=":"
directory=$fsl$bufname$fsl
bufname="HelloWorld"
timestamp=`date +%Y-%m-%d:%H:%M:%S`
sumkdir=/BACKUP_TARS/
fil="./location"


#root/sudo only
if [ ! -e $fil ]; then
	echo $cwd >> $fil
	echo "File created. Location of script stored locally for future use."
else
	line=$(head -n 1 location)
	cd $line
fi

if [ ! -d $sumkdir ]; then
	if [[ $EUID -ne 0 ]]; then
	   echo "This script must be run as a sudo su" 
	   exit 1
	else
	echo "Welcome to the backup folder creator. This is either your first run, or you've deleted the folder for your backups. First we'll define the user and group allowed to access the folder. I suggest making a group called backupers or something."
	echo -e "\e[31mPlease Enter the desired user for chowning.\e[0m"
	read usr
	echo -e "\e[31mPlease Enter the desired group for chowning.\e[0m"
	read grp
	mkdir /BACKUP_TARS/
	chown $usr$spacr$grp /BACKUP_TARS/
	clear
	echo "Please select permissions for USER (chmod, 0-7)"
	read usrchd
	clear
	echo "Please select permissions for GROUP (chmod, 0-7)"
	read grpchd
	clear
	echo "Please select permissions for PUBLIC (chmod, 0-7)"
	read pubchd
	clear
	echo "chmod $usrchd$grpchd$pubchd"
	chmod $usrchd$grpchd$pubchd /BACKUP_TARS/
	echo "Would you like to make a subfolder for backups now?"
	echo -e "\e[31m1:\e[0m Yes"
	echo -e "\e[31m2:\e[0m No"
	read frchoice1
		if [ $frchoice1 -eq 1 ]; then
			echo -e "\e[31mPlease enter the name of the folder you want to create.\e[0m"
			read frfldername
			cd /BACKUP_TARS/
			mkdir $frfldername
			chown $usr$spacr$grp $frfldername
		else
			echo "Would you like to backup the home folder now?"
			echo -e "\e[31m1:\e[0m Yes"
			echo -e "\e[31m2:\e[0m No"			
			read ansrtocnt
			if [ $ansrtocnt -eq 1]; then
				cd $line
				'./bash_home_backup.sh'
				exit 0
			fi
			exit 0
		fi
	fi
fi
#root/sudo only

echo "Backup Data From $HOME to /BACKUP_TARS/ ?"
echo -e "\e[31m1:\e[0m Backup Files"
echo -e "\e[31m2:\e[0m Manage Directories"
echo -e "\e[31m3:\e[0m Exit"
read bashboivarsneak
if [ $bashboivarsneak -eq 1 ]; then
	echo -e "Enter the name of the desired destination for home backup.\n Do not enter the full path, just the name of the folder. ie 'folder_1' "
	echo "List of backup folders"
	cd $sumkdir
	pwd
	ls -lah
	read folderchosen
	cd $HOME
	tar -czvf $timestamp.tar.gz /BACKUP_TARS/${!folderchosen}
	else	
		if [ $bashboivarsneak -eq 3 ]; then
		echo "Goodbye."
		exit 0		
		fi
		if [ $bashboivarsneak -eq 2 ]; then
			echo "What action would you like to perform?"
			echo -e "\e[31m1:\e[0m Create subfolder"
			echo -e "\e[31m2:\e[0m List subfolders"
			echo -e "\e[31m3:\e[0m Exit"
			read fldrmenu

			if [ $fldrmenu -eq 1 ]; then
				echo "Please enter the name of the folder"
				read fldrmenu_createname
				echo "Please select permissions for USER (chmod, 0-7)"
				read usrchm
				echo "Please select permissions for GROUP (chmod, 0-7)"
				read grpchm
				echo "Please select permissions for PUBLIC (chmod, 0-7)"
				read pubchm
				echo "Please select user for chown"
				read usrchwn
				echo "Please select group for chown"
				read grpchwn
				cd /BACKUP_TARS/
				echo "Creating $fldrmenu_createname subfolder"
				mkdir $fldrmenu_createname
				chmod $usrchm$grpchm$pubchm $fldrmenu_createname
				echo "chmod $usrchm$grpchm$pubchm"
				echo "chown $usrchwn$spacr$grpchwn"
				chown $usrchwn$spacr$grpchwn $fldrmenu_createname
				echo "Complete."
				sleep 1
				clear
				cd $line
				'./bash_home_backup.sh'	
			fi
		fi
		if [ $fldrmenu -eq 2 ]; then
			echo "Listing subfolders of /BACKUP_TARS/"
			cd /BACKUP_TARS/
			ls -lah
			echo "Hit Enter to Continue >"
			read cwd
			sleep 1
			clear
			cd $line
			'./bash_home_backup.sh'
		fi
		if [ $fldrmenu -eq 3 ]; then
			echo "Goodbye"
			sleep 1
			exit 0
		else
			clear
			cd $line
			'./bash_home_backup.sh'
		fi
fi
