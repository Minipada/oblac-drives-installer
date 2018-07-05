# OBLAC Drives Installer

This installer should be used for installing the OBLAC Drives and related services on **Ubuntu systems**.

## Installation

There are **three different** installation options:

1) Without cloning this repository:

        $ sudo bash -c "$(wget -qO - https://raw.githubusercontent.com/synapticon/oblac-drives-native-installer/master/oblac-drives-native-installer.sh)"
    
2) After cloning this repository:

        $ sudo ./install.sh
    
    During the installation process, the user will need to enter the following:
    - OBLAC Drive bundle version to be installed (e.g **18.2** - [full list of available versions and supported firmwares](https://synapticon-tools.s3.amazonaws.com/firmwares/odb.json))
    - The network inteface to be used for the EtherCAT master (e.g. **eth0, eth1, ens33...**)

3) As an Ansible playbook executed on a remote machine:

        $ ansible-playbook -i vm vm.yml

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

# About OBLAC Drives Automation

Documentation and provisioning scripts to get from a bare-metal machine to a machine that runs OBLAC Drives and dependent services.

## Rationale

OBLAC Drives and the related software like EtherCAT Master, Motion Master and Motion Master Bridge should be delivered to end users as a self-contained runnable. OBLAC Drives is therefore distributed as OVA (virtual appliance) file that can be imported by VMware tools like VMware Player.

This project uses AWS EC2 to import, provision and export the prepared OBLAC Drives virtual machine. It starts off from the clean Ubuntu Server 16.04.3 LTS machine that is already hosted on AWS S3, it runs the Ansible playbook against the imported machine and then requests a create instance export task on AWS EC2. The process of import, provision and export can take up to 2 hours. The most time is consumed by clean-up and AWS EC2 export tasks.

Once exported the image is still not ready to be used by end users. It has configuration that is not correct for the machine, for example it has one bridged network adapter instead of one NAT that is used for serving OBLAC Drives web application and the other bridged network adapter for EtherCAT communication. The purpose of [exports.sh](https://github.com/synapticon/oblac-drives-automation/blob/master/exports.sh) script is to download OBLAC Drives AWS EC2 exports, configure, rename and upload the prepared OBLAC Drives virtual machines for end users.

## Releasing OBLAC Drives Bundle

OBLAC Drives Bundle is a VM or Linux native installer script that runs predefined versions of OBLAC Drives, Motion Master and Motion Master Bridge.

OBLAC Drives Bundle dependencies are defined in JSON file, e.g.:

    [{
      "version": "18.1",
      "dependencies": {
        "oblac-drives": "v1.2.0",
        "motion-master": "v1.6.3",
        "motion-master-bridge": "v1.5.0"
      },
      "firmwares": ["v4.0.0-rc5", "v4.0.0-rc6"]
    }, {
      "version": "18.0",
      "dependencies": {
        "oblac-drives": "v1.1.0",
        "motion-master": "v1.6.2",
        "motion-master-bridge": "v1.4.4"
      },
      "firmwares": ["v3.2.0-rc4", "v4.0.0-rc5"]
    }]

- **version**: uniquely identifies bundle, first two digits represent year, digit after period is a sequence number
- **dependencies**: lists versions of tools that will be running on the target machine
- **firmwares**: lists compatible firmwares, those that will be recommended in OBLAC Drives

Copy odb.json to S3:

    $ aws s3 cp odb.json s3://synapticon-tools/firmwares/odb.json --acl public-read

Do the following before running the [Jenkins job](https://ci2.synapticon.com/job/oblac-drives-automation/job/master/) that builds OBLAC Drives VM and Linux native installer:

- Add new entry(bundle object) to [odb.json](https://s3-eu-west-1.amazonaws.com/synapticon-tools/firmwares/odb.json). Set bundle version, dependencies and compatible firmwares. You may change compatible firmwares at any time as you discover that older or newer releases of firmwares work with this bundle.
- Use the version that you specified in bundle object as bundle_version parameter when running Jenkins job. During the build versions that are specified in dependencies object property will be used to start OBLAC Drives and Motion Master Bridge and to download Motion Master binary from AWS S3.
- Ensure that there is a matching [OBLAC Drives image with tag](https://hub.docker.com/r/synapticon/oblac-drives/tags/) on Docker Hub. If not, go to [Jenkins](https://ci2.synapticon.com/job/oblac-drives/) and build OBLAC Drives image from Git tag.
- Ensure that there is a matching [Motion Master Bridge image with tag](https://hub.docker.com/r/synapticon/motion-master-bridge/) on Docker Hub. If not, go to [Jenkins](https://ci2.synapticon.com/job/motion-master-bridge/) and build Motion Master Brdge image from Git tag.
- Ensure that Motion Master version exists on AWS S3 synapticon-tools/motion-master/release.
- You may specify empty bundle_version when running Jenkins job and in that case latest versions of OBLAC Drives and Motion Master Bridge will be started, Motion Master will be copied from the Motion Master Jenkins job as binary artifact.

## Examples of Using VMware OVF Tool Usage

### Convert a VMX to an OVA

To convert a VMX to an OVA file, type a command like the following:

    $ ovftool ~/vmware/ubuntu-16.04.3-server-amd64/ubuntu-16.04.3-server-amd64.vmx ubuntu-16.04.3-server-amd64.ova

## Upload OVA to S3

    $ aws s3 cp ubuntu-16.04.3-server-amd64.ova s3://oblac-drives/

## VM Import Service Role

    $ aws iam create-role --role-name vmimport --assume-role-policy-document file://trust-policy.json
    $ aws iam put-role-policy --role-name vmimport --policy-name vmimport --policy-document file://role-policy.json

## Import the VM

    $ aws s3api put-object-acl --acl public-read --bucket oblac-drives --key ubuntu-16.04.3-server-amd64.ova
    $ aws ec2 import-image --description "Ubuntu Server 16.04.3 LTS" --license-type BYOL --disk-containers file://containers.json

## Check the Status of the Import Task

    $ aws ec2 describe-import-image-tasks --import-task-ids import-ami-fhartqy5

## Run an Instance

    $ aws ec2 run-instances --image-id ami-b84b4bc2 --count 1 --instance-type t2.micro --subnet-id subnet-adcbe497 --associate-public-ip-address

## Export an Instance

    $ aws ec2 create-instance-export-task --description "Ubuntu Server 16.04.3 LTS" --instance-id i-0e9be87922aac17e6 --target-environment vmware --export-to-s3-task DiskImageFormat=VMDK,ContainerFormat=ova,S3Bucket=oblac-drives

## Monitor Instance Export

    $ aws ec2 describe-export-tasks --export-task-ids export-i-fgtueuv0

## Run playbooks

    $ ansible-playbook -i vm vm.yml
    $ ansible-playbook aws.yml

## Set firmwares bucket CORS

    $ aws s3api put-bucket-cors --bucket "synapticon-tools" --cors-configuration file://cors.json

## Resources

* https://www.vmware.com/support/developer/ovf/
* https://docs.aws.amazon.com/cli/latest/reference/s3/cp.html
* https://docs.aws.amazon.com/vm-import/latest/userguide/vmimport-image-import.html
* https://docs.aws.amazon.com/cli/latest/reference/ec2/run-instances.html
* https://docs.aws.amazon.com/vm-import/latest/userguide/vmexport.html
