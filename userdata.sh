#!/bin/sh
sudo yum update -y
sudo dnf install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd.service
