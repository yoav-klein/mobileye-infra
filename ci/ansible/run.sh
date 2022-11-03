#!/bin/bash

if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "Set the AWS_ACCESS_KEY and AWS_SECRET_KEY environment variables"
    exit 1
fi

docker run -v $PWD:/ansible -w /ansible \
    -e ANSIBLE_HOST_KEY_CHECKING=false \
    -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
    -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
     yoavklein3/ansible:latest \
     ansible-playbook --key-file key -i aws_ec2.yaml jenkins-playbook.yaml

