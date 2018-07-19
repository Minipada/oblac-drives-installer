#!/usr/bin/env bash
#
# Perform git clone of oblac-drives-installer.

WORK_DIR=/tmp/oblac-drives-installer/

git --version >/dev/null 2>&1 || sudo apt-get install -y git
stat $WORK_DIR >/dev/null 2>&1 && rm -rf $WORK_DIR
git clone https://github.com/synapticon/oblac-drives-installer.git $WORK_DIR && \
cd $WORK_DIR
