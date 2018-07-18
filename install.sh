#!/usr/bin/env bash

echo
echo "********** OBLAC Drives Bundle Installer **********"
echo

source install-ansible.sh

ansible-playbook -i "localhost," -c local native.yml && \
echo "Installation was successful. Open \"localhost:6789\" in your browser."
