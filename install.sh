#!/bin/bash
#
# @author: Travis Tran
# @website: https://truong.id
# @notice: run as root

# Install nginx
sudo yum install -y epel-release openssl nginx
sudo systemctl start nginx
sudo systemctl status nginx
sudo systemctl enable nginx

# Apply template settings
./apply.sh
