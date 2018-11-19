echo "Downloading and installing go1.11.2.linux-amd64.tar.gz"
wget https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz /home/multipass/go1.11.2.linux-amd64.tar.gz
tar -xvf go1.11.2.linux-amd64.tar.gz
sudo chown -R root:root ./go
sudo mv go /usr/local
echo "Removing go1.11.2.linux-amd64.tar.gz"
rm go1.11.2.linux-amd64.tar.gz
# build ksonnet from source
echo "Installing ksonnet/ksonnet:master"
go get github.com/ksonnet/ksonnet
cd $GOPATH/src/github.com/ksonnet/ksonnet
make install
