#!/usr/bin/env bash
#
# Perform native installation on UP Squared.

echo
echo "OBLAC Drives Bundle Installer for UP Squared"
echo

source scripts/install-ansible.sh

ansible-playbook -i "localhost," -c local up2.yml --extra-vars="oblac_drives_port=80" && \
echo "Installation was successful."
