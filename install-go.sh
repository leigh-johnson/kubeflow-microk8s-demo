#!/usr/bin/env bash

echo "Downloading and installing go1.11.2.linux-amd64.tar.gz"
wget https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz /home/multipass/go1.11.2.linux-amd64.tar.gz
tar -xvf go1.11.2.linux-amd64.tar.gz
echo "Removing go1.11.2.linux-amd64.tar.gz"
rm go1.11.2.linux-amd64.tar.gz
mkdir -p /home/multipass/work
source /home/multipass/demo/dev.env


echo "Installing ksonnet/ksonnet:master"
go get github.com/ksonnet/ksonnet
cd $GOPATH/src/github.com/ksonnet/ksonnet
sudo apt-get install make
make install
