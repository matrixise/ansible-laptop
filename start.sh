#!/usr/bin/env bash
# This script is just used for the bootstrap, it will download the definitive
# script and will apply the ansible playbook
sudo apt install -y curl

curl -sSL https://raw.githubusercontent.com/matrixise/ansible-laptop/master/bootstrap.sh | bash
