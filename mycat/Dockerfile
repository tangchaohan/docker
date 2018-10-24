FROM centos:7 

ARG mycat_version=1.6.5

MAINTAINER TangChaohan

RUN echo "root:root" | chpasswd
RUN yum -y install net-tools

# install java
ADD http://mirrors.linuxeye.com/jdk/jdk-8u152-linux-x64.tar.gz /usr/local/
RUN cd /usr/local && tar -zxvf jdk-8u152-linux-x64.tar.gz && ls -lna

ENV JAVA_HOME /usr/local/jdk1.8.0_152
ENV CLASSPATH ${JAVA_HOME}/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV PATH $PATH:${JAVA_HOME}/bin

#install mycat
ADD http://dl.mycat.io/1.6.5/Mycat-server-1.6.5-release-20180122220033-linux.tar.gz /usr/local
RUN cd /usr/local && tar -zxvf Mycat-server-1.6.5-release-20180122220033-linux.tar.gz && ls -lna

VOLUME /usr/local/mycat/conf
VOLUME /usr/local/mycat/logs

EXPOSE 8066 9066
#EXPOSE 7066

CMD /usr/local/mycat/bin/mycat console
