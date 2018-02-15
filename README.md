# OBLAC Drives Automation

Documentation and provisioning scripts to get from a bare-metal machine to a machine that runs OBLAC Drives and dependent services.

## Rationale

OBLAC Drives and the related software like EtherCAT Master, Motion Master and Motion Master Bridge should be delivered to end users as a self-contained runnable. OBLAC Drives is therefore distributed as OVA (virtual appliance) file that can be imported by VMware tools like VMware Player.

This project uses AWS EC2 to import, provision and export the prepared OBLAC Drives virtual machine. It starts off from the clean Ubuntu Server 16.04.3 LTS machine that is already hosted on AWS S3, it runs the Ansible playbook against the imported machine and then requests a create instance export task on AWS EC2. The process of import, provision and export can take up to 2 hours. The most time is consumed by clean-up and AWS EC2 export tasks.

Once exported the image is still not ready to be used by end users. It has configuration that is not correct for the machine, for example it has one bridged network adapter instead of one NAT that is used for serving OBLAC Drives web application and the other bridged network adapter for EtherCAT communication. The purpose of [exports.sh](https://github.com/synapticon/oblac-drives-automation/blob/master/exports.sh) script is to download OBLAC Drives AWS EC2 exports, configure, rename and upload the prepared OBLAC Drives virtual machines for end users.

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

## Resources

* https://www.vmware.com/support/developer/ovf/
* https://docs.aws.amazon.com/cli/latest/reference/s3/cp.html
* https://docs.aws.amazon.com/vm-import/latest/userguide/vmimport-image-import.html
* https://docs.aws.amazon.com/cli/latest/reference/ec2/run-instances.html
* https://docs.aws.amazon.com/vm-import/latest/userguide/vmexport.html
