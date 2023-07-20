#!/bin/bash


echo -n "" > ohio.txt
export profile='prod-hemanth'
region=us-east-1

countdown() {
    local start_time=$(date +%s)
    local end_time=$((start_time + 300))  # 10 minutes in seconds

    while true; do
        local current_time=$(date +%s)
        local remaining=$((end_time - current_time))

        if ((remaining <= 0)); then
            echo ""
            break
        fi

        local minutes=$((remaining / 60))
        local seconds=$((remaining % 60))

        printf "\r%02d:%02d remaining..." "$minutes" "$seconds"
        sleep 1
    done

    printf "\n"
}


echo 'copying Below DBs to "OHIO" Region '
echo "###################################"
for db in audinteldb auspigroup chrobinsondb ffsdb fopdb idrivedb shipbob
do

	dt=$(date +%F)
	dbss=$(aws rds describe-db-snapshots --db-instance-identifier $db --snapshot-type automated --profile $profile --region $region --query "DBSnapshots[?SnapshotCreateTime>='$dt'].DBSnapshotIdentifier" --output=text)
	dbss2=$(echo "$db"-"$dt")
	aws rds copy-db-snapshot \
	        --profile $profile \
    		--source-db-snapshot-identifier arn:aws:rds:us-east-1:471201224424:snapshot:"$dbss" \
    		--target-db-snapshot-identifier "$dbss2" \
    		--kms-key-id 3e61ba77-6a83-4376-a3d8-96dda0321044 \
   	 	    --region us-east-2 \
    		--output table > /dev/null &
    	echo "$dbss" | awk -F":" '{print $NF}'
    	
    	aws rds describe-db-snapshots --db-instance-identifier $db --profile $profile --region "us-east-2" --query "DBSnapshots[?SnapshotCreateTime<='$dt'].DBSnapshotIdentifier" --output text >> ohio.txt
sleep 30
done
echo "*************************"
countdown
echo "*************************"
echo "Deleting Below SnapShots from \"OHIO\" region"
echo "###########################################"

while read -r ohioss ;do
aws rds delete-db-snapshot \
    --profile $profile \
    --region "us-east-2" \
    --db-snapshot-identifier "$ohioss" >&/dev/null
    echo $ohioss
done<ohio.txt
rm -rf ohio.txt



