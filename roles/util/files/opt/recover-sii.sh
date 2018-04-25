#!/bin/bash

echo "Recovering the SII..."
sudo ethercat reg_write -p 0 --type int8 0x500 0
sudo ethercat sii_write -p 0 /home/ubuntu/scripts/somanet_cia402.sii
echo "PLEASE POWER CYCLE THE DRIVE!"
