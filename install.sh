#! /bin/bash

if test "$#" -ne 2; then
    echo 'Usage: "./install.sh 18.2 eth0" (18.2 - OBLAC Drives bundle version; eth0 - EtherCAT network interface)'
    exit 1
fi

if ! bash -c 'command -v ansible >/dev/null 2>&1'; then
    sudo apt-get update && \
    sudo apt-get install -y software-properties-common && \
    sudo apt-add-repository -y ppa:ansible/ansible && \
    sudo apt-get update && \
    sudo apt-get install -y ansible
fi

# A workaround for the jmespath problem - must be installed before starting Ansible
sudo apt-get install -y python-jmespath

ansible-playbook -i "localhost," -c local native.yml --extra-vars "bundle_version=${1} ethercat_interface=${2}"
