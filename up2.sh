#!/usr/bin/env bash

echo
echo "********** OBLAC Drives Bundle Installer for UP Squared **********"
echo

source install-ansible.sh

ansible-playbook -i "localhost," -c local up2.yml && \
echo "Installation was successful."
