#!/bin/bash

set -e

cp /home/ec2-user/SageMaker/.condarc /home/ec2-user/.condarc
cp -R /home/ec2-user/SageMaker/.aws /home/ec2-user
chown -R ec2-user /home/ec2-user/.aws