#!/bin/bash

sudo apt-get update

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io -y


sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Start docker permission 
sudo chmod 666 /var/run/docker.sock

# NOTE: This method is not recommended, better add current user to docker executable as well


# Install docker-compose

curl -L https://github.com/docker/compose/releases/download/1.27.4/docker-compose-`uname -s`-`uname -m` > ~/docker-compose
chmod +x ~/docker-compose
sudo mv ~/docker-compose /usr/local/bin/docker-compose


# Clone Docker file
cd ./docker

curl https://raw.githubusercontent.com/kumcp/aws-learning-example/main/docker/Dockerfile.helloworld >> Dockerfile

# Build an image from the current directory
docker build . -f Dockerfile -t codestar_hello_world:1.0.0

# Remove images:
# docker rmi $(docker images -q)

docker run -d --name=codestar_simple_container hw:1.0.0

# Execute some command for debugging
docker exec -it hw:1.0.0

# Demo with mount at runtime
docker run -d \
    -v "$(pwd)"/kipalog:/var/test \
    custom-nginx:v1.1

docker run -d --mount type=bind,source="$(pwd)"/kipalog,target=/var/test custom-nginx:v1.1