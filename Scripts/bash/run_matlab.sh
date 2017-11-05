#!/bin/bash

fswatch -x --event Created ../../Records/ | while read file event; do
   echo $file
   echo $(/Applications/MATLAB_R2016a.app/bin/matlab -nodesktop -nodisplay -r "cd ~/Desktop/MLProjets/VoiceChatboot/STT/; wavfile='$file'; run('~/Desktop/MLProjets/VoiceChatboot/STT/prediction.m')")
   sleep 5
done
