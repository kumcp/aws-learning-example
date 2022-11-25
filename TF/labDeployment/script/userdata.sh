#!/bin/bash

sudo apt-get update -y

sudo apt install gcc gnupg2 -y

gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
cd ~
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 3.0.2

git clone https://github.com/kumcp/db-syncing.git

sudo apt-get install mysql-client libmysqlclient-dev -y

cd db-syncing/

bundle install


sudo apt install nodejs npm -y
sudo npm install --global yarn
bundle exec rake webpacker:install

rails server -b 0.0.0.0 -p 3000