FROM amazonlinux:latest

LABEL maintainer="ferreira.mv@gmail.com"
ENV REFRESHED_AT 2018-12-01

RUN yum install -y awscli jq ImageMagick

ADD img-convert-to-pdf.sh /usr/local/bin/img-convert-to-pdf.sh
RUN chmod +x              /usr/local/bin/img-convert-to-pdf.sh

USER nobody
WORKDIR /tmp

CMD ["/usr/local/bin/img-convert-to-pdf.sh"]

