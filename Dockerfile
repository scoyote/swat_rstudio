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

