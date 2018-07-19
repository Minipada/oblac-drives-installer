#!/usr/bin/env bash
#
# Prompt user to select a network interface for EtherCAT.

printf "\e[1;33m"

printf "\nAvailable network interfaces:\n"
IFS=$'\n' read -rd '' -a ARRAY<<<"$(basename -a /sys/class/net/*)";
ARRAY_LENGTH=${#ARRAY[@]};
for (( i = 0; i < $ARRAY_LENGTH; i++ )); do
  echo "  $i: ${ARRAY[i]}";
done

echo -n "Select the network interface to use for the EtherCAT master (enter the number): "
read id

while [[ ! $id =~ ^[0-9]+$ || $id -ge $ARRAY_LENGTH ]]; do
  echo -n "Incorrect input value, try again: "
  read id
done

ETHERCAT_INTERFACE=${ARRAY[$id]}

printf "\e[0m"
