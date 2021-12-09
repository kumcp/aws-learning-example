#!/bin/bash


sudo apt-get update -y && sudo apt install mysql-server -y

sudo systemctl start mysqld

export REMOTE_USER=myuser
export REMOTE_PW=MyPW@123

mysql -e "CREATE USER '$REMOTE_USER' IDENTIFIED BY '$REMOTE_PW'"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$REMOTE_USER' WITH GRANT OPTION;"

sed -i -E 's/^bind-address[\t ]*= 127.0.0.1/bind-address = 0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf

sudo service mysql restart

