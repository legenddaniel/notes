#!/bin/bash

# wget https://cmake.org/files/v3.10/cmake-3.10.0.tar.gz
# tar xzf cmake-3.10.0.tar.gz
# cd cmake-3.10.0
# ./bootstrap --prefix=/usr
# make
# sudo make install
# sudo yum -y install git
# echo "Pre Pip"
# python --version
# sudo /usr/bin/pip3 install h3
# sudo /usr/bin/pip3 install boto3
# sudo /usr/bin/pip3 install analytics-python
# echo "Post pip"
# sudo aws s3 cp s3://gli-init-scripts/delta-core_2.11-0.5.0.jar /usr/lib/spark/jars/
# sudo aws s3 cp s3://gli-init-scripts/postgresql-42.2.12.jar /usr/lib/spark/jars/

# Install Golang
sudo yum install golang -y
go version
echo "$GOPATH"
# Clone repos. We need all those server side repos. Now use the modified branch. (Ignore this now)

# The data processing should be in `step` instead of here because HBase is installed after bootstraping