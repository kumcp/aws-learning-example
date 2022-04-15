#!/bin/bash

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install mysql 5.7
sudo wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm

md5sum mysql57-community-release-el7-9.noarch.rpm

sudo rpm -ivh mysql57-community-release-el7-9.noarch.rpm
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022

sudo yum install mysql-server -y

# Start mysql service
sudo systemctl start mysqld

export EXPECTED_PW=Mypassword@1

export TEMP_PW=$(sudo grep 'temporary password' /var/log/mysqld.log | grep -oP "[^ ]*$")

#Login the first time and change password
mysql --defaults-extra-file=<(echo $'[client]\npassword='"$TEMP_PW") --connect-expired-password -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$EXPECTED_PW'"

export REMOTE_USER=myuser
export REMOTE_PW=MyPW@123l

mysql --defaults-extra-file=<(echo $'[client]\npassword='"$EXPECTED_PW") -u root -e "CREATE USER '$REMOTE_USER' IDENTIFIED BY '$REMOTE_PW'"
mysql --defaults-extra-file=<(echo $'[client]\npassword='"$EXPECTED_PW") -u root -e "GRANT ALL PRIVILEGES ON *.* TO '$REMOTE_USER' WITH GRANT OPTION;"

