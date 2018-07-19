#!/usr/bin/env bash
#
# Prompt user to select a bundle version to be installed.

printf "\e[1;33m"

printf "\nAvailable OBLAC Drives versions:\n"
IFS=$'\n' read -rd '' -a ARRAY<<<"$(wget -q -O - https://synapticon-tools.s3.amazonaws.com/firmwares/odb.json | grep -w version | awk '{print $2}' | sed "s/\",*//g")";
ARRAY_LENGTH=${#ARRAY[@]};
for (( i = 0; i < $ARRAY_LENGTH; i++ )); do
  echo "  $i: ${ARRAY[i]}";
done

echo -n "Select a version (enter the number): "
read id

while [[ ! $id =~ ^[0-9]+$ || $id -ge $ARRAY_LENGTH ]]; do
  echo -n "Incorrect input value, try again: "
  read id
done

OBLAC_DRIVES_VERSION=${ARRAY[$id]}

printf "\e[0m"
