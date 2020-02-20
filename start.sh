#!/usr/bin/env bash
sudo apt install -y curl

curl -sSL https://raw.githubusercontent.com/matrixise/ansible-laptop/master/bootstrap.sh | bash
