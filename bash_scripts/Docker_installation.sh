#!/bin/bash

echo -e "1. Installating pre-requesties packages"
yum install -y yum-utils device-mapper-persistent-data lvm2 &> /dev/null

echo -e "2. Downloading Docker repo"
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo &> /dev/null

if [[ -f  /etc/yum.repos.d/docker-ce.repo ]]; then
        echo "3. Repo downloaded successfully"
else
        echo "3. Repo download Failed"
        exit
fi

echo -e "4. Installing Docker"
yum install docker -y &> /dev/null
docker_verify=`rpm -qa | grep -ho docker | tr 'A-Z' 'a-z' | head -n 1`
if [[ docker == ${docker_verify} ]]; then
        echo "5. Docker installed successfully"
else
        echo "5. Docker installation failed"
        exit
fi

echo "6. Starting Docker service"
systemctl start docker &> /dev/null

echo "7. Enabling Docker service"
systemctl enable docker &> /dev/null

echo " "
echo "8. Docker service status"
systemctl status docker

