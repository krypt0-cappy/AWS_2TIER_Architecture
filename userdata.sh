#!/bin/sh
sudo yum update -y
sudo dnf install httpd
sudo systemctl start httpd
sudo systemctl status httpd
sudo systemctl enable --now httpd
# sudo service httpd start
# sudo chkconfig httpd on
# sudo systemctl start httpd.service
# sudo systemctl enable httpd
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --reload
sudo touch /var/www/html/index.html
sudo chmod 777 /var/www/html -R
sudo echo This page was built specifically for the Coalfire Technical Challenge! > /var/www/html/index.html