#!/bin/bash

WORK_DIR=$(dirname "$0")

echo "Recovering the SII..."
sudo ethercat reg_write -p 0 --type int8 0x500 0
sudo ethercat sii_write -p 0 ${WORK_DIR}/somanet_cia402.sii
echo "PLEASE POWER CYCLE THE DRIVE!"
