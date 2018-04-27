# OBLAC Drives bundle native installer

This installer should be used for installing the OBLAC Drives bundle natively on **Ubuntu systems** with kernel versions up to and including **4.9**.

## Installation

    $ ./install.sh 18.2 eth0
    
#### Parameters:

- **18.2** - OBLAC Drive bundle version to be installed ([full list of available versions and supported firmwares](https://synapticon-tools.s3.amazonaws.com/firmwares/odb.json))
- **eth0** - the network inteface to be used for EtherCAT

## Usage

    $ sudo oblac-drives [start|stop|restart|log]
