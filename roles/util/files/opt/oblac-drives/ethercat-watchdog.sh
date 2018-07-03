#!/bin/sh

while true
do
  if [ $(ethercat sl | wc -l) -eq 0 ]
  then
    echo "Restarting EtherCAT Master service..."
    systemctl restart ethercat.service
  fi
  sleep 2
done
