#!/bin/bash

sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo chmod 777 /var/www/html
#sudo touch /var/www/html/index.html


echo "<h1>Hello, World</h1>" >> /var/www/html/index.html
echo "<p>DB address: ${db_address}</p>"  >> /var/www/html/index.html
echo "<p>DB port: ${db_port}</p> "  >> /var/www/html/index.html

