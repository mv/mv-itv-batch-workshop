# FROM fedora:latest
# FROM centos:latest
# FROM busybox:latest
# FROM amazonlinux:latest
FROM alpine:latest

LABEL maintainer="ferreira.mv@gmail.com"
ENV REFRESHED_AT 2018-12-01

ADD env-show.sh /usr/local/bin/env-show.sh
RUN chmod +x    /usr/local/bin/env-show.sh

USER nobody
WORKDIR /tmp

CMD ["/usr/local/bin/env-show.sh"]

