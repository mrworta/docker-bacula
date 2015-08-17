# Bacula Storage Daemon (Compile on Create)
# Version 0.2
# 
# Usage: 
# 1) Edit your data/bacula-sd.conf
# 2) Run "docker build -t bacula-sd ." from the location where the Dockerfile lives. 
#    This will download, compile and prepare bacula.
# 3) Start your container and export ports/volumes. e.g.:
#    "docker run -p 9103:9103 -v /host/directory:/opt/data -d bacula-sd"
#
# - Needs internet. ^^
# - Should run where ever docker is working. Tested on Synology DS1815+ and CentOS6/7.
# - 
#

FROM centos:centos7
MAINTAINER MrWorta - NightSky Services

# Prepare container
RUN mkdir -p /opt/data
RUN yum install -y gcc gcc-cpp git make gcc-c++ zlib-devel openssl-devel bc sqlite-devel

# Clone and checkout bacula
RUN cd /usr/src && git clone http://git.bacula.org/bacula
#
# *** If you need another Bacula-Release, just edit the tag:
RUN cd /usr/src/bacula && git checkout tags/Release-7.0.5
#
#
# Configure and compile sd
RUN cd /usr/src/bacula/bacula && ./configure --disable-build-dird --enable-build-stored --prefix=/opt/bacula.current --with-sqlite3 && make install

# Copy config from host to container
COPY data/bacula-sd.conf /opt/bacula.current/etc/

VOLUME /opt/data

# Do the work thing
CMD /opt/bacula.current/etc/bacula-ctl-sd start; tail -F /var/log/messages

EXPOSE 9103
