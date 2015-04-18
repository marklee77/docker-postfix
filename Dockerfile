FROM phusion/baseimage:latest
MAINTAINER Mark Stillwell <mark@stillwell.me>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -y install \
        mailutils \
        postfix \
        postfix-cdb \
        postfix-ldap \
        postfix-mysql \
        postfix-pcre \
        postfix-pgsql \
        postfix-policyd-spf-python && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

#ADD master.cf /etc/postfix/master.cf

ADD postfix.sh /etc/my_init.d/10-postfix

RUN mkdir -p /var/spool/postfix/etc/ssl/certs

hosts localtime nsswitch.conf resolv.conf services
     
chmod 755 /etc/my_init.d/10-postfix

# data volumes
VOLUME [ "/etc/postfix", "/var/log", "/var/spool/mail" ]

# interface ports
EXPOSE 25 587
