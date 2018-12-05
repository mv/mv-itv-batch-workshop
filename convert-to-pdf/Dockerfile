FROM amazonlinux:latest

LABEL maintainer="ferreira.mv@gmail.com"
ENV REFRESHED_AT 2018-12-01

RUN yum update -y aws-cli  ImageMagick  jq

ADD convert-from-sqs.run.sh /usr/local/bin/convert-from-sqs.run.sh
RUN chmod +x                /usr/local/bin/convert-from-sqs.run.sh

USER nobody
WORKDIR /tmp

ENTRYPOINT ["/usr/local/bin/convert-from-sqs.run.sh"]

