#!/bin/bash

sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

sudo apt-get update
sudo apt install nginx -y
cd ~/
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs


curl -LO https://github.com/kumcp/aws-learning-example/raw/main/demo-project/aws-basis-s3-presigned-url-master.zip
unzip ./aws-basis-s3-presigned-url-master.zip

cd ./aws-basis-s3-presigned-url-master

npm install && node index.js