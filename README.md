# swat_rstudio
Docker container build for creating a SAS Viya SWAT ready R container. No SAS license is required as SAS swat is open source, but you will need a Viya instance to use the swat library.

I have put a few dockerfiles in here but the main Dockerfile is the one to use for building this image. I used centos 6 because it doesn't matter much to me what is used, and I am familiar with Centos 6 R configuration.

The x11 were a carry over from a previous project and I left them in for a reason, though you could probably drop them. THe rest are necessary for explicit and implicit dependency resolution. 

~~~
FROM centos:6
MAINTAINER scoyote

# Install libraries and clean all
RUN yum update -y \
 && yum -y install numactl-libs.x86_64 \
   numactl \
   passwd \
   libXp \
   libpng12 \
   libXmu.x86_64 \
   xterm \
   xorg-x11-apps \
   xorg-x11-server-utils \
   xorg-x11-server-Xorg \
   xorg-x11-xauth \
   git \
   wget \
   openssl-devel \
   libcurl-devel \ 
  && yum -y --enablerepo=extras install epel-release \
  && yum groupinstall "Development tools" -y \
  && yum -y install R \
  && yum clean all \
  && useradd -m -u 1047 -p ".a/xezhRLXhMk%" sasdemo \
  && R -e "install.packages(c('jsonlite','dplyr','httr'), dependencies=T, repos='https://cran.rstudio.com/')" \
  && wget https://github.com/sassoftware/R-swat/releases/download/v1.4.1/R-swat-1.4.1-linux64.tar.gz \
  && wget https://download2.rstudio.org/server/centos6/x86_64/rstudio-server-rhel-1.2.5033-x86_64.rpm \
  && R CMD INSTALL R-swat-1.4.1-linux64.tar.gz \
  && yum -y install rstudio-server-rhel-1.2.5033-x86_64.rpm \
  && rm -f rstudio-server-rhel-1.2.5033-x86_64.rpm R-swat-1.4.1-linux64.tar.gz
COPY start.sh /start.sh
ENTRYPOINT "/start.sh"
~~~

This script installs R and RStudio, creates a sasdemo user (pw: password) to demonstrate RStudio logging in - not SAS login, and sets up the script to start RStudio. There are other ways to do this but this is how I have it at the moment.

# Building the Container
Make sure your current working directory has the Dockerfile and the start.sh script. I call this image r_swat but obviousoy you can call it whatever you would like.
~~~
docker build -t r_swat .
~~~
# Running the container
This run command will start the container in the background and it will run until stopped. It maps the RStudio default port 8787 to itself and 
~~~
docker run -d -p 8787:8787 r_swat
~~~
# Accessing the Command Line
~~~
% docker ps
CONTAINER ID        IMAGE               COMMAND                   CREATED             STATUS              PORTS                    NAMES
3e0e656c1b04        r_swat              "/bin/sh -c \"/start.…"   About an hour ago   Up About an hour    0.0.0.0:8787->8787/tcp   nice_kowalevski
% docker exec -it nice_kowalevski /bin/bash
~~~



