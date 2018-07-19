#! /bin/bash
#
# Perform native installation.

echo
echo "OBLAC Drives Native Installer"
echo

source scripts/select-bundle-version.sh
source scripts/select-network-interface.sh

source scripts/clone-installer.sh

source scripts/install-ansible.sh

ansible-playbook -i "localhost," -c local native.yml --extra-vars "bundle_version=$OBLAC_DRIVES_VERSION ethercat_interface=$ETHERCAT_INTERFACE" && \
echo "Installation was successful. Open the address \"localhost:6789\" in your browser."
