#!/bin/bash

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

yum install httpd -y
service httpd start
chkconfig httpd on

cd /var/www/html
echo "<html>" > index.html

echo "<h1>Welcome to CodeStar</h1>" >> index.html
echo "<h4>You are running instance from this IP (This is for testing purpose only, you should not public this to user):</h4>"
METADATA='http://169.254.169.254'
status_code=$(curl -s -o /dev/null -w "%{http_code}" $METADATA/latest/meta-data/)
if [[ "$status_code" -eq 200 ]]
then
    export privateIp=`curl $METADATA/latest/meta-data/local-ipv4`
    export publicIP=`curl $METADATA/latest/meta-data/public-ipv4`
else
    TOKEN=`curl -X PUT "$METADATA/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
    export privateIp=`curl -H "X-aws-ec2-metadata-token: $TOKEN" -v $METADATA/latest/meta-data/local-ipv4`
    export publicIP=`curl -H "X-aws-ec2-metadata-token: $TOKEN" -v $METADATA/latest/meta-data/public-ipv4`
fi   
echo "<br>Private IP: " >> index.html
echo $privateIp >> index.html

echo "<br>Public IP: " >> index.html
echo $publicIP >> index.html 
echo "</html>" >> index.html