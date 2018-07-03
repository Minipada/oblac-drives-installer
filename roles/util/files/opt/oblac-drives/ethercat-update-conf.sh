#!/bin/sh

MASTER0_DEVICE="$(cat /sys/class/net/ens33/address)"
cp /opt/etherlab/etc/sysconfig/ethercat /etc/ethercat.conf
sed -i "s/DEVICE_MODULES=\"\"/DEVICE_MODULES=\"generic\"/g" /etc/ethercat.conf
sed -i "s/MASTER0_DEVICE=\"\"/MASTER0_DEVICE=\"${MASTER0_DEVICE}\"/g" /etc/ethercat.conf
