# docker-tomcat

The `docker-tomcat` image provides a Docker container for running Tomcat 8 Server 
based on [openjdk](https://hub.docker.com/_/openjdk/) official image.

This container is provided with a full Tomcat installation.

## Usage

Start a Tomcat instance as follows (using docker-compose.yml file):

	# My docker-compose.yml file
	
	# Tomcat 8.5.15
	tomcat:
	  image: tomcat-server
	  container_name: tomcat-server
	  #network_mode: default
	  extra_hosts:
	  - my_database:192.168.15.224
	  environment:
	  - TOMCAT_PASS=4dm1n.pwd
	  - JAVA_OPTS=-Xms1024m -Xmx2048m -XX:MaxPermSize=256m
	  ports:
	  - 8080:8080

## Configuration (environment variables)

When you start the Tomcat Server image, you can adjust the configuration of the instance by 
passing one or more environment variables on the docker run command line. 

	TOMCAT_PASS

Variable to	define the password for `admin` Tomcat user.

	JAVA_OPTS
	
Variable to define all extra configuration for JVM.

## Data persistence

If you want to make your data persistent, you need to mount a volume.
The first start of this container.

When the server is started (watching logs...):

	docker logs -t --tail=100 tomcat-server
	
	tomcat-server | 01-Jun-2017 08:24:08.685 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["http-nio-8080"]
	tomcat-server | 01-Jun-2017 08:24:08.693 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["ajp-nio-8009"]
	tomcat-server | 01-Jun-2017 08:24:08.699 INFO [main] org.apache.catalina.startup.Catalina.start Server startup in 696 ms


the folder **webapps** could be copied from container to host and
then could be used as a **volume**. To do these:

	docker cp tomcat-server:/opt/tomcat/webapps/ <PATH_INTO_HOST>
	
When the folder is copied, you only need to mount the volume, adding the following lines
to the docker-compose.yml file used previously:

	volumes:
	  - <PATH_INTO_HOST>/webapps:/opt/tomcat/webapps
	  
After that, recreate the container using your own and persisted data!

