# OBLAC Drives Native Installer

This installer should be used for installing the OBLAC Drives and related services natively on **Ubuntu systems** with kernel versions up to and including **4.9**.

## Installation

There are **two different** installation options:

1) Without cloning this repository:

        $ sudo bash -c "$(wget -qO - https://raw.githubusercontent.com/synapticon/oblac-drives-native-installer/master/oblac-drives-native-installer.sh)"
    
 2) After cloning this repository:

        $ ./install.sh
    
During the installation process, the user will need to enter the following:
- OBLAC Drive bundle version to be installed (e.g **18.2** - [full list of available versions and supported firmwares](https://synapticon-tools.s3.amazonaws.com/firmwares/odb.json))
- The network inteface to be used for the EtherCAT master (e.g. **eth0, eth1, ens33...**)

## Usage

    $ sudo oblac-drives [start|stop|restart|log]
