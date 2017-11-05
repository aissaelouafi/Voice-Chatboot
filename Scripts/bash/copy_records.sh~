#!/bin/bash
# this script copy the new record from spool/ASTERISK/monitor to shared folder

inotifywait -m /var/spool/asterisk/monitor -e create -e moved_to -e modify |
	while read path action file; do
		echo "The file '$file' apperaed in directory '$path' via '$action'"
		cp $path$file /media/sf_Voice_Chatboot_/Records/$file
		echo "The file '$file' copied to /media/sf_Voice_Chatboot_/Records folder"
	done

