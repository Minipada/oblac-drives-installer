#!/usr/bin/env bash

deploy () {
    cp exports/$1/$1-disk-1.vmdk exports/$1/$2-disk-1.vmdk
    cp exports/$1/$1.mf exports/$1/$2.mf
    cp export-i-base.ovf exports/$1/$2.ovf
    sed -i -e "s/export-i-base/${2}/g" exports/$1/$2.ovf
    openssl sha1 exports/$1/$2-disk-1.vmdk exports/$1/$2.ovf > exports/$1/$2.mf
    tar -cf exports/$1/$2.ova -C exports/$1/ $2.ovf $2-disk-1.vmdk $2.mf
    aws s3 cp exports/$1/$2.ova s3://oblac-drives-vms
    aws s3 rm s3://oblac-drives-vms/$1.ova
    rm -rf exports/$1
}

aws s3 sync s3://oblac-drives-vms exports/ --exclude="*" --include="export-*"

for file in exports/*.ova
do
    if [[ $file =~ ^exports/(.*)\.ova$ ]]; then
        name=${BASH_REMATCH[1]}
        if [ -d exports/$name ]; then
            continue
        fi
        mkdir exports/$name
        tar -xf $file -C exports/$name/
        deploy $name oblac-drives
        suffix=`date +%Y%m%d-%H%M`
        deploy $name oblac-drives-${suffix}
    fi
done
