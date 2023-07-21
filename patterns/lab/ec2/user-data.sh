#!/bin/bash

sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo chmod 777 /var/www/html
#sudo touch /var/www/html/index.html


echo "<h1>Hello, World From Standalone Ec2 Instance </h1>" >> /var/www/html/index.html
echo "<h1>I am not load balanced : $ {instance_desc} </h1>" >> /var/www/html/index.html


