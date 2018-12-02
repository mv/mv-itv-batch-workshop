FROM amazonlinux:latest

RUN yum -y install which unzip aws-cli

ADD my-environment.sh /usr/local/bin/

WORKDIR /tmp
USER nobody

ENTRYPOINT ["/usr/local/bin/my-environment.sh"]

