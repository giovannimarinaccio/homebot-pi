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
sudo mkdir -p /share/public
sudo mkdir -p /share/private
sudo tee -a /etc/samba/smb.conf <<EOT

[public]
    comment = Public Folder
    path = /share/public
    writable = yes
    guest ok = yes
    guest only = yes
    force create mode = 666
    force directory mode = 0777
    browseable = yes
[private]
    comment = Private Folder
    path = /share/private
    writable = yes
    guest ok = no
    valid users = @smbshare
    force create mode = 770
    force directory mode = 770
    inherit permissions = yes

EOT

# Create users and groups

sudo groupadd smbshare
sudo chgrp -R smbshare /share/private/
sudo chgrp -R smbshare /share/public
sudo chmod 2770 /share/private/
sudo chmod 2777 /share/public
sudo useradd -M -s /sbin/nologin sambauser
sudo usermod -aG smbshare sambauser
sudo smbpasswd -a sambauser -w sambapass
sudo smbpasswd -e sambauser

# restart service
sudo testparm
sudo systemctl restart nmbd
