#!/bin/bash

[ "$HOST_IP1" ] || HOST_IP1="10.1.8.55"
[ "$HOST_IP2" ] || HOST_IP2="10.1.8.54"
#[ "$HOST_IP3" ] || HOST_IP3="10.1.8.53"

cp -f caiyun-fastdfs-tracker-cluster.yml caiyun-fastdfs-tracker-cluster.yml.temp
sed -i 's/IP1/'$HOST_IP1'/g' caiyun-fastdfs-tracker-cluster.yml.temp
sed -i 's/IP2/'$HOST_IP2'/g' caiyun-fastdfs-tracker-cluster.yml.temp
#sed -i 's/IP3/'$HOST_IP3'/g' caiyun-fastdfs-tracker-cluster.yml.temp
docker stack deploy -c ./caiyun-fastdfs-tracker-cluster.yml.temp caiyun-fastdfs-tracker-cluster
rm -rf ./caiyun-fastdfs-tracker-cluster.yml.temp
