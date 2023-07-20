#!/bin/bash

echo "Script to Reboot Production RDS Instances servers"
  ###### AWS Configuration SETUP ##########
  export AWS_DEFAULT_REGION=us-east-1
  export AWS_PROFILE=prod-hemanth

# RDS instance identifiers
RDS_INSTANCES=("audinteldb" "auspigroup" "chrobinsondb" "ffsdb" "fopdb" "idrivedb" "shipbob")

# Function to start RDS instances
start_rds_instances() {
  for instance in "${RDS_INSTANCES[@]}"; do
    aws rds start-db-instance --db-instance-identifier "$instance"
    echo "Starting RDS instance: $instance"
  done
}

# Function to stop RDS instances
stop_rds_instances() {
  for instance in "${RDS_INSTANCES[@]}"; do
    aws rds stop-db-instance --db-instance-identifier "$instance"
    echo "Stopping RDS instance: $instance"
  done
}
countdown() {
        # Wait for 10 minutes
        WAIT_TIME=600
        while [ $WAIT_TIME -gt 0 ]; do
          printf "Countdown: %02d:%02d \r" $((WAIT_TIME / 60)) $((WAIT_TIME % 60))
          sleep 1
          ((WAIT_TIME--))
        done
        echo ""
}

if [ "$(date +%A)" = "Sunday" ]; then
      # Stop RDS instances
      stop_rds_instances
       # Wait for 10 minutes
      countdown
      # Start RDS instances
      start_rds_instances
else
  zenity --info \
    --text="Access Denied....\n\nPlease try On Sunday"
fi


