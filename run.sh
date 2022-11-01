#!/bin/bash


command="$@"

[ -z "$command" ] && echo "Enter command" && exit 1

docker run -v $HOME/.aws:/root/.aws \
    -v $PWD:/terraform -w /terraform hashicorp/terraform:latest $command

