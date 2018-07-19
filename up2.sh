#!/usr/bin/env bash
#
# Perform native installation on UP Squared.

echo
echo "OBLAC Drives Bundle Installer for UP Squared"
echo

source scripts/install-ansible.sh

ansible-playbook -i "localhost," -c local up2.yml && \
echo "Installation was successful."
