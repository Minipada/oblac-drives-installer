#!/usr/bin/env bash

aws s3 cp odb.json s3://synapticon-tools/firmwares/odb.json --acl public-read
