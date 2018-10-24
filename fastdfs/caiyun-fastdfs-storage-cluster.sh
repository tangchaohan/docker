#!/bin/bash

[ "$HOST_IP1" ] || HOST_IP1="10.1.8.55"
[ "$HOST_IP2" ] || HOST_IP2="10.1.8.54"
[ "$TRACKER_CLUSTER" ] || TRACKER_CLUSTER="10.1.8.55:22122,10.1.8.54:22122"

cp -f caiyun-fastdfs-storage-cluster.yml caiyun-fastdfs-storage-cluster.yml.temp
sed -i 's/IP1/'$HOST_IP1'/g' caiyun-fastdfs-storage-cluster.yml.temp
sed -i 's/IP2/'$HOST_IP2'/g' caiyun-fastdfs-storage-cluster.yml.temp
sed -i 's/TRACKER_CLUSTER/'$TRACKER_CLUSTER'/g' caiyun-fastdfs-storage-cluster.yml.temp
docker stack deploy -c ./caiyun-fastdfs-storage-cluster.yml.temp caiyun-fastdfs-storage-cluster
rm -rf ./caiyun-fastdfs-storage-cluster.yml.temp
