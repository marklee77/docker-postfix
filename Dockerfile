FROM ubuntu:latest
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

ADD postfix.sh /root/
