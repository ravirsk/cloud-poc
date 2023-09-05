#!/bin/bash

sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo chmod 777 /var/www/html
#sudo touch /var/www/html/index.html


echo "<h1>Hello, World From Standalone Ec2 Instance </h1>" >> /var/www/html/index.html
echo "<h1>I am not load balanced : $ {instance_desc} </h1>" >> /var/www/html/index.html

sudo yum install java-17-amazon-corretto

wget https://cloudarchitect.jfrog.io/artifactory/libs-release/student-services-security-0.0.1-SNAPSHOT.jar

sudo chmod 777 student-services-security-0.0.1-SNAPSHOT.jar

java -jar -Dserver.port=8081 student-services-security-0.0.1-SNAPSHOT.jar com.in28minutes.springboot.StudentServicesApplication &