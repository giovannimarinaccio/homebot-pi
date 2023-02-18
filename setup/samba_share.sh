#!/usr/bin/env bash
set -e
sudo apt-get update
sudo apt-get install samba smbclient cifs-utils
sudo apt-get autoremove -y
