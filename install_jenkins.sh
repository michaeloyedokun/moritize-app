#!/bin/bash

# Ensure latest java version is running on server
sudo yum update -y
echo 'install wget and java'
sudo yum install wget
sudo amazon-linux-extras install java-openjdk11
sudo amazon-linux-extras install epel -y
echo 'jenkins install'
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install jenkins -y
echo 'start jenkins'
sudo service jenkins start
