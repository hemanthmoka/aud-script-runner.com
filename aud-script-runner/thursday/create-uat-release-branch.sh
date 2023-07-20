#!/bin/bash
PROFILE=default
REGION=us-east-1

cat > repositories.txt << EOF
    ai-parcel-reports
    ai-parcel-web
    ai-parcel-tasks
    fop-freight-parceltms
    traceui
    traceui2
    traceui3
    traceui4
    traceui6
EOF


cat > EventRules.txt << EOF
    codepipeline-aiparc-faceli-445038-rule ai-parcel-web
    codepipeline-aiparc-faceli-735062-rule ai-parcel-reports
    codepipeline-fopfre-faceli-103309-rule fop-freight-parceltms
    codepipeline-traceu-faceli-126681-rule traceui
    codepipeline-traceu-faceli-779129-rule traceui2
    codepipeline-traceu-faceli-485726-rule traceui3
    codepipeline-traceu-uatrel-174861-rule traceui4
EOF
cat > uat-pipeline-list.txt << EOF
    uat-ai-parcel-web-faclift
    uat-ai-reports-web-faclift
    uat-fop-freight-parceltms-faclift
    uat-Audintel-traceui-facelift
    uat-audintel-traceui2-facelift-pipeline
    uat-audintel-traceui3-facelift
    uat-Audintel-traceui4-facelift
    uat-audintel-traceui6-react18-pipeline1
    uat-chrobinson-traceui-facelift
    uat-chrobinson-traceui2-facelift-pipeline
    uat-chrobinson-traceui3-facelift
    uat-fop-traceui-facelift
    uat-fop-traceui2-facelift-pipeline
    uat-fop-traceui3-facelift
    uat-FOP-traceui4-facelift
    uat-fop-traceui6-react18-pipeline
EOF
#Functions Decleration

#### BRANCH CREATION IN aws CODECOMMIT FROM MAIN BRANCH  #########
dt=$(zenity --calendar --date-format %Y-%m-%d)
branch=uat-release-$dt

function Branch_Creation() {
    echo "                     Creating Branch: $branch for all Below repositories.." | boxes -d stone -p a2v1
    cat repositories.txt
    echo "====================================="
    while read -r repo; do
    commitID="$(aws codecommit get-branch --profile $PROFILE --region $REGION --repository-name "$repo" --branch-name main --output text | awk '{print $3}')"
    aws codecommit create-branch --profile $PROFILE --region $REGION --repository-name "$repo" --branch-name "$branch" --commit-id "$commitID"
    [ $? -eq 0 ] && echo "$repo -- $branch" || echo "$repo ????"
    done < repositories.txt
 }

#### UPDATE NEW BRANCH IN EVENT BRIDGE RULES  #########

function EventRules_Updation() {
    #### UPDATING EVENT BRIDGE RULES TO LATEST UAT-RELEASE BRANCH #########
    echo "                       Updating Event Bridge Rules with New Branch: $branch" | boxes -d stone -p a2v1

    while read -r rule repo; do
    aws events put-rule --profile $PROFILE --region $REGION --name "$rule" --event-pattern "{\"source\":[\"aws.codecommit\"],\"detail-type\":[\"CodeCommit Repository State Change\"],\"resources\":[\"arn:aws:codecommit:us-east-1:267077890961:""$repo""\"],\"detail\":{\"event\":[\"referenceCreated\",\"referenceUpdated\"],\"referenceType\":[\"branch\"],\"referenceName\":[\"$branch\"]}}" --output text
    done < EventRules.txt
}

#### UPDATE NEW BRANCH IN RESPECTIVE PIPELINES  #########

function Pipelines_Updation() {
    #### UPDATING AWS CODEPIPELINES WITH LATEST UAT-RELEASE BRANCH #########
    echo "                       Updating pipelines with New Branch: $branch" | boxes -d stone -p a2v1
    New="$branch"
    while read -r pip; do
    aws codepipeline --profile $PROFILE --region $REGION get-pipeline --name "$pip" > "$pip".json						#getting code pipeline json
    Old="$(grep Branch "$pip".json | awk '{print $2}' | sed "s/\"//g" | sed "s/\,//g")" 						#extracting existing branch in pipeline
    echo -e "$pip -- $(grep Branch "$pip".json | awk -F":" '{print $NF}')" 								#displaying existing branch name in pipeline

    l="$(wc -l < "$pip".json)"
    x="$((l-6))"
    sed "$x d;$((x+1))d;$((x+2))d;$((x+3))d;$((x+4))d" "$pip".json> "$pip"1.json
    sed "s/""$Old""/""$New""/" "$pip"1.json > "$pip".json
    aws codepipeline --profile $PROFILE --region $REGION update-pipeline --cli-input-json file://"$pip".json > /dev/null 2>&1		#update code pipeline 
    echo -e "$pip -- $(aws codepipeline --profile $PROFILE --region $REGION get-pipeline --name $pip --output json | grep Branch | awk -F":" '{print $NF}')\n" #Display old and new branch in pipeline
    rm -rf ./*.json
    done < uat-pipeline-list.txt
}


#Main Program

    if [ -z $dt ];then
        echo "I hope you are not willing to run this script.Exiting..."
        exit
    else
      Branch_Creation;
      EventRules_Updation;
      Pipelines_Updation;
        #for i in $(zenity --list --title "Select Service" --text "Select Operation" --checklist --column "Select" --column "Operation" 1 "Branch-Creation" 2 "EventRules-Updation" 3 "Pipelines-Updation" |  awk 'BEGIN {FS="|";OFS=" "; print ""} {$1=$1}1')
        #do
        #    ($(echo $i))
        #done
     	echo "Hi Team,  $branch Branch has been created for this week." |  pbcopy
	pbpaste
	open -a "Slack" "slack://channel?team=TGLJXF0TS&id=C01UMMEATMK"
    fi

rm -rf {EventRules,repositories,uat-pipeline-list}.txt
