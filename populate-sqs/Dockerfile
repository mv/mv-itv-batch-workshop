FROM amazonlinux:latest

LABEL maintainer="ferreira.mv@gmail.com"
ENV REFRESHED_AT 2018-12-01

RUN yum install -y awscli  curl

ADD ./populate-sqs.sh /usr/local/bin/populate-sqs.sh
RUN chmod +x          /usr/local/bin/populate-sqs.sh

ENV PS1='\u@\h:\w\n\$ '

USER nobody
WORKDIR /tmp

CMD ["/usr/local/bin/populate-sqs.sh"]

