#!/bin/bash

WAIT_TIME=600
while [ $WAIT_TIME -gt 0 ]; do
  printf "Countdown: %02d:%02d \r" $((WAIT_TIME / 60)) $((WAIT_TIME % 60))
  sleep 1
  ((WAIT_TIME--))
done
echo ""