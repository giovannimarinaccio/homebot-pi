#!/usr/bin/env bash
set -e
sudo apt-get update
sudo apt-get install -y samba smbclient cifs-utils
sudo apt-get autoremove -y

if [ -f "/etc/samba/smb.conf.orig" ]
then
    echo "/etc/samba/smb.conf.orig already exists"
    sudo cp /etc/samba/smb.conf.orig /etc/samba/smb.conf
else
    sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.orig
    echo "/etc/samba/smb.conf.orig created"
fi
sudo mkdir -p /public
sudo mkdir -p /private
cat <<EOT >> /etc/samba/smb.conf
[public]
    comment = Public Folder
    path = /public
    writable = yes
    guest ok = yes
    guest only = yes
    force create mode = 775
    force directory mode = 775
[private]
    comment = Private Folder
    path = /private
    writable = yes
    guest ok = no
    valid users = @smbshare
    force create mode = 770
    force directory mode = 770
    inherit permissions = yes
EOT

# restart service
sudo systemctl restart nmbd