#!/usr/bin/env bash
#
# Perform installation of Ansible.

if ! bash -c 'command -v ansible >/dev/null 2>&1'; then
  sudo apt-get update && \
  sudo apt-get install -y software-properties-common && \
  sudo apt-add-repository -y ppa:ansible/ansible && \
  sudo apt-get update && \
  sudo apt-get install -y ansible

  rc=$?;
  if [[ $rc != 0 ]]; then
    echo
    echo 'Failed to install Ansible! Run "sudo apt-get update" and check for any errors. Once the errors are resolved, try installing again.';
    echo
    exit $rc;
  fi
fi

# A workaround for the jmespath problem - must be installed before starting Ansible
if ! bash -c 'dpkg -l python-jmespath >/dev/null 2>&1'; then
  sudo apt-get install -y python-jmespath
fi
