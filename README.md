# OBLAC Drives Native Installer

This installer should be used for installing the OBLAC Drives and related services natively on **Ubuntu systems** with kernel versions up to and including **4.9**.

## Installation

There are **two different** installation options:

1) Without cloning this repository:

        $ sudo bash -c "$(wget -qO - https://raw.githubusercontent.com/synapticon/oblac-drives-native-installer/master/oblac-drives-native-installer.sh)"
    
2) After cloning this repository:

        $ sudo ./install.sh
    
During the installation process, the user will need to enter the following:
- OBLAC Drive bundle version to be installed (e.g **18.2** - [full list of available versions and supported firmwares](https://synapticon-tools.s3.amazonaws.com/firmwares/odb.json))
- The network inteface to be used for the EtherCAT master (e.g. **eth0, eth1, ens33...**)

### The following software will be installed

1) IgH EtherCAT master
2) Ansible
3) Docker
4) Git
5) build-essential
6) autoconf
7) libtool
8) python3-pip
9) Motion Master
10) Motion Master Bridge
11) OBLAC Drives

## Usage

    $ sudo oblac-drives [start|stop|restart|log]
