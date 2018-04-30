#! /bin/bash

echo
echo "********** OBLAC Drives bundle installer **********"
echo

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

ansible-playbook -i "localhost," -c local native.yml && \
echo "Installation successfully finished. Please open the address \"localhost\" in a browser."
