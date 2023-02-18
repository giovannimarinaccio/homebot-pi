#!/usr/bin/env bash
set -e
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y zip unzip tar git curl wget vi less
sudo apt-get autoremove -y
