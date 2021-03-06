#!/bin/bash
# this script copy the new record from spool/ASTERISK/monitor to shared folder

inotifywait -m /var/spool/asterisk/monitor -e create -e moved_to -e modify |
	while read path action file; do
		if [ "$action" == "CREATE" ]; then
			echo "The file '$file' apperaed in directory '$path' via '$action'"
			sleep 10
			cp $path$file /media/sf_VoiceChatboot/Records/$file
			echo "The file '$file' copied to /media/sf_VoiceChatboot/Records folder"
		fi
	done
