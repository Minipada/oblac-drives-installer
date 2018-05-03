#! /bin/bash

echo
echo "********** OBLAC Drives bundle installer **********"
echo

WORK_DIR=/tmp/oblac-drives-native-installer/

# Automatic OBLAC Drives native installer
git --version >/dev/null 2>&1 || sudo apt-get install git
stat $WORK_DIR >/dev/null 2>&1 && rm -rf $WORK_DIR
git clone https://github.com/synapticon/oblac-drives-native-installer.git $WORK_DIR && \
cd $WORK_DIR

# Install dependencies
if ! bash -c 'command -v ansible >/dev/null 2>&1'; then
    sudo apt-get update && \
    sudo apt-get install -y software-properties-common && \
    sudo apt-add-repository -y ppa:ansible/ansible && \
    sudo apt-get update && \
    sudo apt-get install -y ansible
fi

# A workaround for the jmespath problem - must be installed before starting Ansible
if ! bash -c 'dpkg -l python-jmespath >/dev/null 2>&1'; then
    sudo apt-get install -y python-jmespath
fi

# Let the user select the version of the bundle to be installed
printf "\e[1;33m"
printf "\nAvailable OBLAC Drives versions:\n"
IFS=$'\n' read -rd '' -a ARRAY<<<"$(wget -q -O - https://synapticon-tools.s3.amazonaws.com/firmwares/odb.json | grep -w version | awk '{print $2}' | sed "s/\",*//g")";
ARRAY_LENGTH=${#ARRAY[@]};
for (( i = 0; i < $ARRAY_LENGTH; i++ )); do
    echo "  $i: ${ARRAY[i]}";
done

echo -n "Please select a version (enter the number): "
read id

while [[ ! $id =~ ^[0-9]+$ || $id -ge $ARRAY_LENGTH ]]; do
    echo -n "Incorrect input value, please try again: "
    read id
done

OBLAC_DRIVES_VERSION=${ARRAY[$id]}

# Let the user select the network interface to be used for the EtherCAT master
printf "\nAvailable network interfaces:\n"
IFS=$'\n' read -rd '' -a ARRAY<<<"$(basename -a /sys/class/net/*)";
ARRAY_LENGTH=${#ARRAY[@]};
for (( i = 0; i < $ARRAY_LENGTH; i++ )); do
    echo "  $i: ${ARRAY[i]}";
done

echo -n "Please select the network interface to use for the EtherCAT master (enter the number): "
read id

while [[ ! $id =~ ^[0-9]+$ || $id -ge $ARRAY_LENGTH ]]; do
    echo -n "Incorrect input value, please try again: "
    read id
done

ETHERCAT_INTERFACE=${ARRAY[$id]}

printf "\e[0m"

ansible-playbook -i "localhost," -c local native.yml --extra-vars "bundle_version=$OBLAC_DRIVES_VERSION ethercat_interface=$ETHERCAT_INTERFACE" && \
echo "Installation successfully finished. Please open the address \"localhost:6789\" in a browser."
