#!/bin/bash

if [[ test-bridge = $(docker network ls | grep -ho test-bridge) ]]; then
	echo "test-bridge already created"
else
	docker network create -d bridge --subnet 192.168.0.0/16 test-bridge
	echo "test-bridge created successfully"
fi
docker run -itd --name $1 --network test-bridge -p :22 -p :8140 -p :8141 -h $1 -v /sys/fs/cgroup:/sys/fs/cgroup --privileged=true centos/systemd /usr/sbin/init

docker exec -it $1 echo "nameserver 8.8.8.8" >> /etc/resolv.conf
docker exec -it $1 yum install  initscripts -y
docker exec -it $1 yum install openssh-server openssh-clients -y
docker exec -it $1 echo -e "Administrator@123\nAdministrator@123" | passwd
docker exec -it $1 sed -i '/PermitRootLogin/d' /etc/ssh/sshd_config > /dev/null
docker exec -it $1 sed -i '10i\PermitRootLogin yes' /etc/ssh/sshd_config > /dev/null
docker exec -it $1 systemctl restart sshd

echo "$i - Container created successfully" 
