#!/bin/bash
profile=default
region=us-east-1
if [ "$(date +%A)" = "Wednesday" ];then

cat >repositories.txt<< EOF
ai-parcel-reports
ai-parcel-web
fop-freight-parceltms
traceui
traceui2
traceui3
traceui4
traceui6
EOF

dt=$(date +%Y-%m-%d)
branch=staging-$dt
zenity --text-info \
       --title="$branch" \
       --filename=repositories.txt \
       --checkbox="I read and accept the terms."

case $? in
    0)
        echo "Creating Branches...!"
        while read -r repo; do
		commitID="$(aws codecommit --profile "$profile" --region "$region" get-branch --repository-name "$repo" --branch-name main --output text | awk '{print $3}')"
		aws codecommit create-branch --profile "$profile" --region "$region" --repository-name "$repo" --branch-name "$branch" --commit-id "$commitID"
		echo -e "$repo \n$(aws codecommit --profile "$profile" --region "$region" list-branches --repository-name "$repo" --output text | grep staging)" | boxes -d stone -a c
	done < repositories.txt 
        ;;
    1)
        echo "No Staging Branches Created!"
        ;;
    -1)
        echo "An unexpected error has occurred."
        ;;
esac
echo "Hi Team , created $branch  branch (web , reports ,fop-freight-parceltms, traceui , traceui2, traceui3, traceui4, traceui6) for today’s release." | pbcopy
rm -rf repositories.txt
open -a "Slack" "slack://channel?team=TGLJXF0TS&id=C01UMMEATMK"

else
zenity --info \
--text="Access Denied....\n\nPlease try On Wednesday"
fi
rm -rf repositories.txt
