#!/usr/bin/env bash

sudo apt install -y python3-pip git
python3 -m pip install --user --upgrade pipx
~/.local/bin/pipx install ansible

git clone https://github.com/matrixise/ansible-laptop

pushd ansible-laptop
~/.local/bin/ansible-galaxy install -r requirements.yml --force
~/.local/bin/ansible-playbook -K --ask-vault-pass playbook.yml
popd
