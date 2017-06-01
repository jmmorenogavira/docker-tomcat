FROM openjdk:8u131
MAINTAINER Jose Manuel Moreno Gavira <josem.moreno.gavira@gmail.com>

# locales
RUN		apt-get -y update

#apt-get install -yq --no-install-recommends libtcnative-1 && \
RUN apt-get install -yq --no-install-recommends wget pwgen ca-certificates locales && \
	apt-get install -yq make gcc libc6-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN localedef -i en_US -f UTF-8 en_US.UTF-8

ENV	LANG en_US.utf8

ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_MINOR_VERSION 8.5.15
ENV CATALINA_HOME /opt/tomcat
ENV JAVA_OPTS ""
ENV LD_LIBRARY_PATH /usr/local/apr/lib

# Tomcat Server
COPY files/apache-tomcat-8.5.15.tar.gz /opt/
RUN tar -zxvf /opt/apache-tomcat-8.5.15.tar.gz -C /opt/
RUN mv /opt/apache-tomcat-8.5.15 /opt/tomcat
RUN rm /opt/apache-tomcat-8.5.15.tar.gz

ADD files/create_tomcat_admin_user.sh /create_tomcat_admin_user.sh
ADD files/run.sh /run.sh
RUN chmod +x /*.sh

# OpenSSL
COPY files/openssl-1.1.0f.tar.gz /opt/
RUN tar -zxvf /opt/openssl-1.1.0f.tar.gz -C /opt/
RUN cd /opt/openssl-1.1.0f && ./config --prefix=/usr/ && make && make install
RUN rm /opt/openssl-1.1.0f.tar.gz

# APR
COPY files/apr-1.5.2.tar.gz /opt/
RUN tar -zxvf /opt/apr-1.5.2.tar.gz -C /opt/
RUN cd /opt/apr-1.5.2 && ./configure && make && make install
RUN rm /opt/apr-1.5.2.tar.gz

# Tomcat Native 
COPY files/tomcat-native-1.2.12-src.tar.gz /opt/
RUN tar -zxvf /opt/tomcat-native-1.2.12-src.tar.gz -C /opt/
RUN cd /opt/tomcat-native-1.2.12-src/native && ./configure --with-apr=/usr/local/apr --with-java-home=$JAVA_HOME && make && make install
RUN rm /opt/tomcat-native-1.2.12-src.tar.gz

EXPOSE 8080

CMD ["/run.sh"]
