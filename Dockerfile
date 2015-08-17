# Bacula Storage Daemon (compile on docker build)

FROM centos:centos7
MAINTAINER MrWorta - NightSky Services

RUN mkdir -p /opt/data

RUN useradd bacula
RUN yum install -y gcc gcc-cpp git make gcc-c++ zlib-devel openssl-devel bc sqlite-devel
RUN cd /usr/src && git clone http://git.bacula.org/bacula
RUN cd /usr/src/bacula && git checkout tags/Release-7.0.5
RUN cd /usr/src/bacula/bacula && ./configure --disable-build-dird --enable-build-stored --prefix=/opt/bacula.cu

VOLUME /opt/bacula.current/etc
VOLUME /opt/data

CMD /opt/bacula.current/etc/bacula-ctl-sd start; tail -F /var/log/messages

EXPOSE 9103