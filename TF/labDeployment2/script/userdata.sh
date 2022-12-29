#!/bin/bash

echo " ===== Install NPM ====="
sudo apt-get update
sudo apt install npm -y

echo " ===== Clone project ====="
cd /var/www/html
git clone https://github.com/kumcp/kumu.git

cd ./kumu/kumu-web-client/
echo " ===== Install dependencies ====="
npm install

npm run build


echo " ===== Install nginx ====="
sudo apt install nginx -y

sed -i -E 's+root /var/www/html;+root /kumu/kumu-web-client/dist;+g' /etc/nginx/sites-enabled/default

sudo service nginx restart
