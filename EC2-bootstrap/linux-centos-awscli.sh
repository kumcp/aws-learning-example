#!/bin/bash

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

yum install httpd -y
service httpd start
chconfig httpd on

cd /var/www/html
echo "<html>" > index.html

echo "<h1>Welcome to CodeStar</h1>" >> index.html
echo "<h4>You are running instance from this IP (This is for testing purpose only, you should not public this to user):</h4>"
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://169.254.169.254/latest/meta-data/)
if [[ "$status_code" -eq 200 ]]
then
    export METADATA='http://169.254.169.254'
else
    export TOKEN=`curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
    export METADATA='-s -H X-aws-ec2-metadata-token: '$TOKEN' http://169.254.169.254'
fi   
echo "<br>Private IP: " >> index.html
curl $METADATA/latest/meta-data/local-ipv4 >> index.html

echo "<br>Public IP: " >> index.html
curl $METADATA/latest/meta-data/public-ipv4 >> index.html 
echo "</html>" >> index.html
