FROM registry.access.redhat.com/ubi8/ubi:latest as BUILDER

ENV TZ="America/New_York"

# Set timezone and update certificates
RUN yum update -y --disablerepo=* --enablerepo=ubi-8-appstream --enablerepo=ubi-8-baseos \
 && yum -y install tzdata ca-certificates \
 && update-ca-trust \
 && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
 && echo $TZ > /etc/timezone \
 && mkdir -p /tmp/chrony/logs \
 && yum clean all \
 && rm -rf /var/cache/yum \
 && rm -rf /var/log/*

# Install ChronyD
RUN yum -y install chrony \
 && yum clean all \
 && rm -rf /var/cache/yum \
 && rm -rf /var/log/*

COPY chrony.conf /etc/chrony.conf

# NTP port exposed
EXPOSE 123/udp

# Start Chronyd on container start
CMD [ "/usr/sbin/chronyd", "-d", "-s"]