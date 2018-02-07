# OBLAC Drives Automation


## Examples of Using VMware OVF Tool Usage

### Convert a VMX to an OVA

To convert a VMX to an OVA file, type a command like the following:

    $ ovftool ~/vmware/Ubuntu\ Server\ 16.04.3\ LTS/Ubuntu\ Server\ 16.04.3\ LTS.vmx Ubuntu\ Server\ 16.04.3\ LTS.ova

## Upload OVA to S3

    $ aws s3 cp ubuntu-server-16.04.3-lts.ova s3://oblac-drives-vms/

## VM Import Service Role

    $ aws iam create-role --role-name vmimport --assume-role-policy-document file://trust-policy.json
    $ aws iam put-role-policy --role-name vmimport --policy-name vmimport --policy-document file://role-policy.json

## Import the VM

    $ aws s3api put-object-acl --acl public-read --bucket oblac-drives-vms --key ubuntu-16.04.3-server-amd64.ova
    $ aws ec2 import-image --description "Ubuntu Server 16.04.3 LTS" --license-type BYOL --disk-containers file://containers.json

## Check the Status of the Import Task

    $ aws ec2 describe-import-image-tasks --import-task-ids import-ami-fhartqy5

## Run an Instance

    $ aws ec2 run-instances --image-id ami-b84b4bc2 --count 1 --instance-type t2.micro --subnet-id subnet-adcbe497 --associate-public-ip-address

## Export an Instance

    $ aws ec2 create-instance-export-task --instance-id i-09e4657a5c19464ca --target-environment vmware --export-to-s3-task DiskImageFormat=VMDK,ContainerFormat=ova,S3Bucket=oblac-drives-vms

## Monitor Instance Export

    $ aws ec2 describe-export-tasks --export-task-ids export-i-fgtueuv0

## Run playbook

    $ ansible-playbook -i inventory playbook.yml

## Resources

* https://www.vmware.com/support/developer/ovf/
* https://docs.aws.amazon.com/cli/latest/reference/s3/cp.html
* https://docs.aws.amazon.com/vm-import/latest/userguide/vmimport-image-import.html
* https://docs.aws.amazon.com/cli/latest/reference/ec2/run-instances.html
* https://docs.aws.amazon.com/vm-import/latest/userguide/vmexport.html
