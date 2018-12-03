# FROM amazonlinux:latest
# FROM alpine:latest
# FROM centos:latest
FROM busybox:latest

ADD my-environment.sh /usr/local/bin/my-environment.sh
RUN chmod +x          /usr/local/bin/my-environment.sh

USER nobody
WORKDIR /tmp

ENTRYPOINT ["/usr/local/bin/my-environment.sh"]
