#!/usr/bin/env zsh
dt=$(zenity --calendar --date-format %Y-%m-%d)
staging_branch=staging-$dt

#if [ -z "$1" ] ; then

# echo "Usage: \n $0 mm-dd";exit
 
# else
for repo in ai-parcel-reports ai-parcel-web fop-freight-parceltms ai-parcel-tasks traceui traceui2 traceui3 traceui4 traceui6 ;do
	aws codecommit list-branches --repository-name $repo | grep "$staging_branch" | sort | awk '{print r," ",$1}' r=$repo | sed "s/\"//g" | sed "s/\,//g" >> sbranches
done


zenity --text-info \
       --title="$branch" \
       --filename=sbranches \
       --checkbox="I read and accept the terms."
 
 
 case $? in
    0)
        echo "Deleting Staging Branches...!"
        while read -r repo branch;do
	 	echo Deleting "$branch" from "$repo"
		aws codecommit delete-branch --repository-name "$repo" --branch-name "$branch"
 		done<sbranches

        ;;
    1)
        echo "No Branches Deleted!"
        ;;
    -1)
        echo "An unexpected error has occurred."
        ;;
esac

rm -rf sbranches
#fi