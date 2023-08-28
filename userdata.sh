#!/bin/sh
sudo yum update -y
sudo yum -y install httpd
sudo systemctl enable httpd
sudo systemctl start httpd.service
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --reload
sudo touch /var/www/html/index.html
sudo chmod 777 /var/www/html -R
sudo echo This page was built specifically for the Coalfire Technical Challenge! > /var/www/html/index.html