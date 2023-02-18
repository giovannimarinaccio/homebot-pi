#!/usr/bin/env bash
set -e
sudo apt-get update
sudo apt-get install -y zip unzip tar git curl wget vim less
sudo apt-get upgrade -y
sudo apt-get autoremove -y
