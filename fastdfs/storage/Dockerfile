FROM centos:7

MAINTAINER TangChaohan

ENV FASTDFS_PATH=/opt/fdfs \
    FASTDFS_BASE_PATH=/opt/fastdfs \
    PORT= \
    GROUP_NAME= \
    TRACKER_SERVER=

  

#get all the dependences
RUN yum install -y git gcc make

#create the dirs to store the files downloaded from internet
RUN mkdir -p ${FASTDFS_PATH}/libfastcommon \
 && mkdir -p ${FASTDFS_PATH}/fastdfs \
 && mkdir -p ${FASTDFS_PATH}/fastdfs-nginx \
 && mkdir -p ${FASTDFS_PATH}/nginx-install \
 && mkdir -p ${FASTDFS_PATH}/nginx \
 && mkdir ${FASTDFS_BASE_PATH} 


#compile the libfastcommon
WORKDIR ${FASTDFS_PATH}/libfastcommon

RUN git clone --depth 1 https://github.com/happyfish100/libfastcommon.git ${FASTDFS_PATH}/libfastcommon \
 && ./make.sh \
 && ./make.sh install \
 && rm -rf ${FASTDFS_PATH}/libfastcommon

#compile the fastdfs
WORKDIR ${FASTDFS_PATH}/fastdfs

RUN git clone --depth 1 https://github.com/happyfish100/fastdfs.git ${FASTDFS_PATH}/fastdfs \
 && ./make.sh \
 && ./make.sh install \
 && rm -rf ${FASTDFS_PATH}/fastdfs

#compile the fastdfs-nginx
WORKDIR ${FASTDFS_PATH}/fastdfs-nginx

RUN git clone --depth 1 https://github.com/happyfish100/fastdfs-nginx-module.git ${FASTDFS_PATH}/fastdfs-nginx


#install nginx
WORKDIR ${FASTDFS_PATH}/nginx-install

RUN yum -y install zlib zlib-devel openssl* pcre pcre-devel gd-devel wget\
  && wget http://nginx.org/download/nginx-1.14.0.tar.gz  \
  && tar -zxvf nginx-1.14.0.tar.gz \
  && cd nginx-1.14.0 \
  && ./configure --prefix=/${FASTDFS_PATH}/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_realip_module --with-http_gzip_static_module --with-stream --with-http_image_filter_module --add-module=${FASTDFS_PATH}/fastdfs-nginx/src \
  && make \
  && make install \
  && rm -f /${FASTDFS_PATH}/nginx/conf/nginx.conf


 
 
EXPOSE 23000 8888 80
VOLUME ["$FASTDFS_BASE_PATH", "/etc/fdfs"]   

COPY conf/*.* /etc/fdfs/

COPY nginx.conf /${FASTDFS_PATH}/nginx/conf

COPY start.sh /usr/bin/

#make the start.sh executable 
RUN chmod 777 /usr/bin/start.sh

HEALTHCHECK --interval=60s --timeout=10s --retries=5 --start-period=30s  CMD curl -f http://127.0.0.1/ || exit 1 

ENTRYPOINT ["/usr/bin/start.sh"]
CMD ["tracker"]
