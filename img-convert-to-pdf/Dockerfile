FROM amazonlinux:2

LABEL maintainer="ferreira.mv@gmail.com"
ENV REFRESHED_AT 2018-12-01

RUN yum install -y curl python3 python3-pip && pip3 install img2pdf awscli

ADD img-convert-to-pdf.sh /usr/local/bin/img-convert-to-pdf.sh
RUN chmod +x              /usr/local/bin/img-convert-to-pdf.sh

USER nobody
WORKDIR /tmp

CMD ["/usr/local/bin/img-convert-to-pdf.sh"]

