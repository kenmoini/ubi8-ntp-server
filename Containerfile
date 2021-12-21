FROM registry.access.redhat.com/ubi8/ubi:latest as BUILDER

ENV TZ="America/New_York"

# Set timezone and update certificates
RUN yum update -y --disablerepo=* --enablerepo=ubi-8-appstream --enablerepo=ubi-8-baseos \
 && yum -y install tzdata ca-certificates \
 && update-ca-trust \
 && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
 && echo $TZ > /etc/timezone \
 && yum clean all \
 && rm -rf /var/cache/yum \
 && rm -rf /var/log/*

# Install ChronyD
RUN yum -y install chrony \
 && yum clean all \
 && rm -rf /var/cache/yum \
 && rm /etc/chrony.conf \
 && rm -rf /var/log/*

# Copy files
COPY --chown=chrony:chrony ./entrypoint /opt/entrypoint

# Create directories
RUN mkdir -p /tmp/chrony/logs \
 && mkdir -p /etc/chrony \
 && mkdir -p /run/chrony/logs \
 && mkdir -p /var/lib/chrony \
 && chown -R chrony:chrony /tmp/chrony/ \
 && chown -R chrony:chrony /run/chrony/ \
 && chown -R chrony:chrony /var/lib/chrony/ \
 && chown -R chrony:chrony /etc/chrony/ \
 && chmod -R 0700 /run/chrony/ \
 && rm -rf /var/log/*

# Set permissions
RUN chown -R chrony:chrony /tmp/chrony/ \
 && chown -R chrony:chrony /run/chrony/ \
 && chown -R chrony:chrony /var/lib/chrony/ \
 && chown -R chrony:chrony /etc/chrony/ \
 && chmod 775 /opt/entrypoint \
 && rm -rf /var/log/*

# NTP port exposed
EXPOSE 123/udp

# Set a User to run the container (chrony:chrony = 991:987)
USER chrony

# Start Chronyd on container start
CMD [ "/opt/entrypoint" ]