#!/bin/bash

sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo chmod 777 /var/www/html
echo "<h1>Hello, World From Standalone EC2 </h1>" >> /var/www/html/index.html
echo "<h1>I am not load balanced : $ {instance_desc} </h1>" >> /var/www/html/index.html
sudo mkdir -p /home/app_data
sudo chmod 777 /home/app_data
echo "Installing My Spring Boot App" >> /home/app_data/appinstalllog.txt
sudo yum install java-17-amazon-corretto >> /home/app_data/appinstalllog.txt
echo "Installed JAVA" >> /home/app_data/appinstalllog.txt 
wget https://cloudarchitect.jfrog.io/artifactory/libs-release/student-services-security-0.0.1-SNAPSHOT.jar >> /home/app_data/appinstalllog.txt
sudo chmod 777 student-services-security-0.0.1-SNAPSHOT.jar >> /home/app_data/appinstalllog.txt
echo "Downloaded Jar" >> /home/app_data/appinstalllog.txt 
java -jar -Dserver.port=8081 student-services-security-0.0.1-SNAPSHOT.jar com.in28minutes.springboot.StudentServicesApplication & >> /home/app_data/appinstalllog.txt