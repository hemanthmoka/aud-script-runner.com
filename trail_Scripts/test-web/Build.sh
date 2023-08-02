#!/bin/bash

# Prompt for an option and store the selected value
#option=$(osascript -e 'choose from list {"liquibase", "no-liquibase"} with title "Form" with prompt "Select an option:" default items {"no-liqibase"}')

# Prompt for items and store the selected ones
#servers=$(osascript -e 'choose from list {"audintel", "auspi", "chr", "fop", "idrive", "shipbob", "ti"} with title "ask server selection " with prompt "Select Servers:" with multiple selections allowed' | awk 'BEGIN {FS=",";OFS=" "; print ""} {$1=$1}1')

echo -e "cd pinging \n ls *-pingserver.log \n ./build.sh \n ./run.sh $1 \n tail -f *-pingserver.log" | pbcopy

#for server in $2 ; do
#osascript -e "tell application \"Terminal\" to do script \"ssh $server\" with title "$option - $server""
#osascript -e 'tell application \"Terminal\" to do script \ls \'
#echo $1 -- $2
echo "ssh $2" > $2.command ;chmod +x $2.command;open $2.command

#done

#sleep 10
#rm -rf ./*command*