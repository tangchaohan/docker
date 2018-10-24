#!/bin/bash
#set -e
if [ "$1" = "monitor" ] ; then
  if [ -n "$TRACKER_SERVER" ] ; then  
    #sed -i "s|tracker_server=.*$|tracker_server=${TRACKER_SERVER}|g" /etc/fdfs/client.conf
     trackers="$TRACKER_SERVER"
     array=(${trackers//,/ })
     for var in ${array[@]}
     do
       sed -i "1itracker_server=$var" /etc/fdfs/client.conf
     done 
  fi
  fdfs_monitor /etc/fdfs/client.conf
  exit 0
elif [ "$1" = "storage" ] ; then
  FASTDFS_MODE="storage"
else 
  FASTDFS_MODE="tracker"
fi

if [ -n "$PORT" ] ; then  
sed -i "s|^port=.*$|port=${PORT}|g" /etc/fdfs/"$FASTDFS_MODE".conf
fi

if [ -n "$TRACKER_SERVER" ] ; then  
trackers="$TRACKER_SERVER"
array=(${trackers//,/ })
for var in ${array[@]}
do
  sed -i "1itracker_server=$var" /etc/fdfs/storage.conf
  sed -i "1itracker_server=$var" /etc/fdfs/client.conf
  sed -i "1itracker_server=$var" /etc/fdfs/mod_fastdfs.conf
#  echo "tracker_server=$var" >> /etc/fdfs/storage.conf
#  echo "tracker_server=$var" >> /etc/fdfs/client.conf
#  echo "tracker_server=$var" >> /etc/fdfs/mod_fastdfs.conf
done

#sed -i "s|tracker_server=.*$|tracker_server=${TRACKER_SERVER}|g" /etc/fdfs/storage.conf
#sed -i "s|tracker_server=.*$|tracker_server=${TRACKER_SERVER}|g" /etc/fdfs/client.conf

fi

if [ -n "$GROUP_NAME" ] ; then  

sed -i "s|group_name=.*$|group_name=${GROUP_NAME}|g" /etc/fdfs/storage.conf

fi 

FASTDFS_LOG_FILE="${FASTDFS_BASE_PATH}/logs/${FASTDFS_MODE}d.log"
PID_NUMBER="${FASTDFS_BASE_PATH}/data/fdfs_${FASTDFS_MODE}d.pid"

echo "try to start the $FASTDFS_MODE node..."
if [ -f "$FASTDFS_LOG_FILE" ]; then 
	rm "$FASTDFS_LOG_FILE"
fi
# start the fastdfs node.	
fdfs_${FASTDFS_MODE}d /etc/fdfs/${FASTDFS_MODE}.conf start

# wait for pid file(important!),the max start time is 5 seconds,if the pid number does not appear in 5 seconds,start failed.
TIMES=5
while [ ! -f "$PID_NUMBER" -a $TIMES -gt 0 ]
do
    sleep 1s
	TIMES=`expr $TIMES - 1`
done

#start nginx
echo "start nginx"
echo "$FASTDFS_MODE"
if [ "$FASTDFS_MODE" = "storage" ] ; then
   echo "begin"
   sed -i "s|STORAGE|${FASTDFS_BASE_PATH}|g" ${FASTDFS_PATH}/nginx/conf/nginx.conf
   ln -s ${FASTDFS_BASE_PATH}/data/  ${FASTDFS_BASE_PATH}/data/M00
   ${FASTDFS_PATH}/nginx/sbin/nginx -c ${FASTDFS_PATH}/nginx/conf/nginx.conf
fi

# if the storage node start successfully, print the started time.
# if [ $TIMES -gt 0 ]; then
#     echo "the ${FASTDFS_MODE} node started successfully at $(date +%Y-%m-%d_%H:%M)"
	
# 	# give the detail log address
#     echo "please have a look at the log detail at $FASTDFS_LOG_FILE"

#     # leave balnk lines to differ from next log.
#     echo
#     echo

    
	
# 	# make the container have foreground process(primary commond!)
#     tail -F --pid=`cat $PID_NUMBER` /dev/null
# # else print the error.
# else
#     echo "the ${FASTDFS_MODE} node started failed at $(date +%Y-%m-%d_%H:%M)"
# 	echo "please have a look at the log detail at $FASTDFS_LOG_FILE"
# 	echo
#     echo
# fi
tail -f "$FASTDFS_LOG_FILE"
