#!/bin/bash

sudo sed -i "s/PermitRootLogin no/PermitRootLogin yes/g" /etc/sshd/sshd_config
sudo sed -i "s/PasswordAuthentication yes/PasswordAuthentication no/g" /etc/sshd/sshd_config
sudo systemctl restart sshd