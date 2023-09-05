#!/bin/bash

sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo chmod 777 /var/www/html
echo "<h1>Hello, World From Standalone EC2 </h1>" >> /var/www/html/index.html
echo "<h1>I am not load balanced : $ {instance_desc} </h1>" >> /var/www/html/index.html
echo "Installing My Spring Boot App" >> logs.txt
sudo yum install java-17-amazon-corretto >> logs.txt
echo "Installed JAVA" >> logs.txt 
wget https://cloudarchitect.jfrog.io/artifactory/libs-release/student-services-security-0.0.1-SNAPSHOT.jar >> logs.txt
sudo chmod 777 student-services-security-0.0.1-SNAPSHOT.jar >> logs.txt
echo "Downloaded Jar" >> logs.txt 
java -jar -Dserver.port=8081 student-services-security-0.0.1-SNAPSHOT.jar com.in28minutes.springboot.StudentServicesApplication & >> logs.txt