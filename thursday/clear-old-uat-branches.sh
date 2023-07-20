
#dt=$(zenity --calendar --date-format %Y-%m-%d)
dt=2023-06-21
uat_branch=uat-release-$dt
    echo -n "" > branches
    if [ -z $dt ];then
        echo "I hope you are not willing to run this script...."
        exit
    else
      #Getting Branches list for specified repositories
        for repo in ai-parcel-reports ai-parcel-web ai-parcel-tasks fop-freight-parceltms traceui traceui2 traceui3 traceui4 traceui6 ;do
          aws codecommit list-branches --repository-name "$repo" --output text | grep "$uat_branch" | sort | awk '{print r," ",$2}' r=$repo >> branches
          #sed "s/\"//g" | sed "s/\,//g"      ###to replace " & , with space
        done

       #Verification of branche names to delete
                  zenity --text-info \
                         --title="$branch" \
                         --filename=branches \
                         --checkbox="I read and accept the terms."

        #Deleting Specified Branches
                   case $? in
                      0)
                          echo "deleting Branches...!"
                          while read -r repo branch;do
                        aws codecommit delete-branch --repository-name "$repo" --branch-name "$branch" >&/dev/null
                        echo "$repo" - "$branch" Deleted....
                      done<branches

                          ;;
                      1)
                          echo "No Branches Deleted!"
                          ;;
                      -1)
                          echo "An unexpected error has occurred."
                          ;;
                  esac

        #deleting temperory text file having branch names
        rm -rf branches
    fi