#!/usr/bin/env bash
set -e
sudo apt-get update
sudo apt-get install -y samba smbclient cifs-utils
sudo apt-get autoremove -y
