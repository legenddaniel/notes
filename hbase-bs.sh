#!/bin/bash

# Install utils
sudo yum update -y
sudo yum install -y git
sudo yum install golang -y
sudo yum install cmake -y
sudo amazon-linux-extras install docker

# Add hbase docker network to host file
sudo -- sh -c -e "echo '127.0.0.1 ground-level-insights-hbase-docker' >> /etc/hosts"

# Create root folder
mkdir app
cd app

# Grab server scripts from s3.
# I did not directly git clone them because I have not found a way to hide git credentials.
# These codes have to be updated from local repo to S3
mkdir backend-shared
sudo aws s3 cp --recursive s3://gli-emr-scripts/backend-shared ./backend-shared/
mkdir client-portal-api
sudo aws s3 cp --recursive s3://gli-emr-scripts/client-portal-api ./client-portal-api/
mkdir config
sudo aws s3 cp --recursive s3://gli-emr-scripts/config ./config/
mkdir dev
sudo aws s3 cp --recursive s3://gli-emr-scripts/dev ./dev/
mkdir data-processing
sudo aws s3 cp --recursive s3://gli-emr-scripts/data-processing ./data-processing/

# Start Docker
sudo chkconfig docker on
sudo systemctl start docker

# Init server and storages
cd dev
sudo make setup-backend
cd tools/mysql
sudo make mysql-start
cd ../hbase
sudo make hbase-start
cd ../..
sudo make migrate CONFIG=dev
cd ../data-processing/visits-processing/service/dev
sudo make migrate

# Start xmode data processing
cd ../../../xmode-import/service/dev
sudo make run