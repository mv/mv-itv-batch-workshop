FROM python:3.7.1-alpine

LABEL maintainer="ferreira.mv@gmail.com"
ENV REFRESHED_AT 2018-12-01

RUN pip install awscli

# open tar and link 'bin' to '/kaiju/bin'
ADD kaiju-1.6.3-linux-x86_64.tar.gz    /kaiju/
RUN ln -snf /kaiju/kaiju-v*-static/bin /kaiju/bin

# Fix: no need for './kaiju' -- kaiju goes into $PATH
ENV PATH=/kaiju/bin:/usr/local/bin:/usr/bin:/bin

# just in case: PS1 for 'docker run ... /bin/sh'
ENV PS1='\u@\h:\w\n\$ '

# run: takes care for parameters
ADD start.kaiju.sh /usr/local/bin/start.kaiju.sh
RUN chmod +x       /usr/local/bin/start.kaiju.sh

WORKDIR /tmp
CMD ["/usr/local/bin/start.kaiju.sh"]

