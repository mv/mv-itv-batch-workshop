# FROM fedora:latest
# FROM centos:latest
# FROM busybox:latest
# FROM amazonlinux:latest
FROM alpine:latest

LABEL maintainer="ferreira.mv@gmail.com"
ENV REFRESHED_AT 2018-12-01

ADD my-environment.sh /usr/local/bin/my-environment.sh
RUN chmod +x          /usr/local/bin/my-environment.sh

USER nobody
WORKDIR /tmp

ENTRYPOINT ["/usr/local/bin/my-environment.sh"]

