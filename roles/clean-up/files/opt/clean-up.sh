#!/usr/bin/env bash

# This script zeroes out any space not needed for packaging a new Ubuntu virtual machine.

function print_green {
  echo -e "\e[32m${1}\e[0m"
}

# root user check - this script MUST be ran with root privileges
if [[ "$EUID" -ne 0 ]]; then
  echo "ERROR: This script MUST be ran as root"
  exit 1
fi

print_green 'Clean Apt'
apt-get autoclean
apt-get clean
apt-get -y autoremove

print_green 'Cleanup bash history'
unset HISTFILE
[ -f /root/.bash_history ] && rm /root/.bash_history
[ -f /home/ubuntu/.bash_history ] && rm /home/ubuntu/.bash_history
 
print_green 'Cleanup log files'
find /var/log -type f | while read f; do echo -ne '' > $f; done
 
print_green 'Whiteout root'
count=`df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}'`
let count--
dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count
rm /tmp/whitespace
 
print_green 'Whiteout /boot'
count=`df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}'`
let count--
dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count;
rm /boot/whitespace

#print_green 'Whiteout swap'
#swappart=`cat /proc/swaps | tail -n1 | awk -F ' ' '{print $1}'`
#swapoff $swappart
#dd if=/dev/zero of=$swappart
#mkswap -f $swappart
#swapon $swappart

print_green 'Zero out disk'
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

print_green 'Machine clean-up complete!'
