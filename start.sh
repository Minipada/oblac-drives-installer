#! /bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

ansible-playbook -i "localhost," -c local start.yml
echo "Please open the address \"localhost\" in a browser"
