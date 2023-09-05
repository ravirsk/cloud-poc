#!/bin/bash

sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo chmod 777 /var/www/html
#sudo touch /var/www/html/index.html
echo "<h1>Hello, World From Standalone EC2 Instance </h1>" >> /var/www/html/index.html
echo "<h1>I am not load balanced : $ {instance_desc} </h1>" >> /var/www/html/index.html
echo "Installing My Spring Boot App" >> logs.txt
sudo yum install java-17-amazon-corretto
echo "Installed JAVA" >> logs.txt
wget https://cloudarchitect.jfrog.io/artifactory/libs-release/student-services-security-0.0.1-SNAPSHOT.jar
sudo chmod 777 student-services-security-0.0.1-SNAPSHOT.jar
echo "Downloaded Jar" >> logs.txt
java -jar -Dserver.port=8081 student-services-security-0.0.1-SNAPSHOT.jar com.in28minutes.springboot.StudentServicesApplication &