#!/bin/bash
####AWS Configuration SETUP#########
export AWS_DEFAULT_REGION=us-east-1
export AWS_PROFILE=prod-hemanth


local_dir=~/Downloads/tim-audintel-$(date +%F)

if [ -d "$local_dir" ] ;then
    rm -rf "$local_dir" ; mkdir -p "$local_dir"
  else mkdir -p "$local_dir"
fi
rm -rf Duplicate_files.txt

touch s3Files.txt ; pbpaste > s3Files.txt; open -t s3Files.txt

sleep 15
# Read the file names from the text file
file_names=$(cat s3Files.txt)
bucket=tim-audintel
prefix=tim
# Iterate over each file name and download from S3
for file_name in $file_names; do
    rfile=$(aws s3 ls "s3://$bucket/$prefix/$file_name" | awk -F " " '{print $NF}')
    count_rfile=$(echo "$rfile" | wc -l)
  #  echo $rfile
  # echo $count_rfile
   if [ "$count_rfile" -gt "1"  ];then
     r2file=$(aws s3 ls "s3://$bucket/$prefix/$file_name" | sort -r | head -1 | awk -F " " '{print $NF}')
     aws s3 cp s3://$bucket/$prefix/"$r2file" "$local_dir"/ >&/dev/null
    echo $file_name >> Duplicate_files.txt
    elif [ "$count_rfile" -eq "1"  ];then
     aws s3 cp s3://$bucket/$prefix/"$rfile" "$local_dir"/"$file_name" >&/dev/null
   fi

done
count=$(ls "$local_dir" | wc -l)
echo "$count" Files are downloaded
if [ "$count" -gt 5 ];then
        cd $HOME/Downloads/ || exit
        zip tim-audintel-"$(date +%F)".zip tim-audintel-"$(date +%F)"/*
  else
    open "$local_dir"
fi

[ -s "Duplicate_files.txt" ] && open -t Duplicate_files.txt || echo No Duplicate Files found
rm -rf s3Files.txt