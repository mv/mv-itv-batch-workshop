FROM amazonlinux:latest

LABEL maintainer="ferreira.mv@gmail.com"
ENV REFRESHED_AT 2018-12-01

ADD convert-image-from-sqs.sh /usr/local/bin/convert-image-from-sqs.sh
RUN chmod +x                  /usr/local/bin/convert-image-from-sqs.sh

USER nobody
WORKDIR /tmp

ENTRYPOINT ["/usr/local/bin/convert-image-from-sqs.sh"]

