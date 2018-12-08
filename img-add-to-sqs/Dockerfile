FROM amazonlinux:latest

LABEL maintainer="ferreira.mv@gmail.com"
ENV REFRESHED_AT 2018-12-01

RUN yum install -y awscli  curl

ADD ./img-add-to-sqs.sh /usr/local/bin/img-add-to-sqs.sh
RUN chmod +x            /usr/local/bin/img-add-to-sqs.sh

ENV PS1='\u@\h:\w\n\$ '

USER nobody
WORKDIR /tmp

CMD ["/usr/local/bin/img-add-to-sqs.sh"]

