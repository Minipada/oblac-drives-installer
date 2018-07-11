#!/bin/sh

# Default interface used inside the OBLAC Drives VM
INTERFACE="ens33"

# If available, use the interface provided as the script argument
if [ "$#" -eq 1 ]; then
    INTERFACE=${1}
fi

MASTER0_DEVICE="$(cat /sys/class/net/${INTERFACE}/address)"
cp /opt/etherlab/etc/sysconfig/ethercat /etc/ethercat.conf
sed -i "s/DEVICE_MODULES=\"\"/DEVICE_MODULES=\"generic\"/g" /etc/ethercat.conf
sed -i "s/MASTER0_DEVICE=\"\"/MASTER0_DEVICE=\"${MASTER0_DEVICE}\"/g" /etc/ethercat.conf
