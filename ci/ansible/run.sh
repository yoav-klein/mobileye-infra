#!/bin/bash

#docker run -v $PWD:/ansible -w /ansible yoavklein3/ansible:latest ansible-galaxy collection list

#docker run -v $PWD:/ansible -w /ansible \
#    yoavklein3/ansible:latest ansible-inventory -i aws_ec2.yaml --graph


docker run -v $PWD:/ansible -w /ansible -e ANSIBLE_HOST_KEY_CHECKING=false yoavklein3/ansible:latest \
     ansible-playbook --key-file key -i aws_ec2.yaml jenkins-playbook.yaml

#docker run -v $PWD:/ansible yoavklein3/ansible:latest ansible-config --version
