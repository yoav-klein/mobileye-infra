#!/bin/bash

if [ -z "$AWS_ACCESS_KEY" ] || [ -z "$AWS_SECRET_KEY" ]; then
    echo "Set the AWS_ACCESS_KEY and AWS_SECRET_KEY environment variables"
    exit 1
fi

docker run -v $PWD:/ansible -w /ansible \
    -e ANSIBLE_HOST_KEY_CHECKING=false \
    -e AWS_ACCESS_KEY="$AWS_ACCESS_KEY" \
    -e AWS_SECRET_KEY="$AWS_SECRET_KEY" \
     yoavklein3/ansible:latest \
     ansible-playbook --key-file key -i aws_ec2.yaml jenkins-playbook.yaml

