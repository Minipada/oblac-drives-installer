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

    rc=$?;
    if [[ $rc != 0 ]]; then
        echo
        echo 'Failed to install Ansible. Please run "sudo apt-get update" and check for any errors. Once the errors are resolved, try installing again.';
        echo
        exit $rc;
    fi
fi

# A workaround for the jmespath problem - must be installed before starting Ansible
if ! bash -c 'dpkg -l python-jmespath >/dev/null 2>&1'; then
    sudo apt-get install -y python-jmespath
fi

ansible-playbook -i "localhost," -c local native.yml && \
echo "Installation successfully finished. Please open the address \"localhost:6789\" in a browser."
