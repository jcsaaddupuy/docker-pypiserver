FROM debian:wheezy
MAINTAINER Jean-Christophe Saad-Dupuy <jc.saaddupuy@fsfe.org>

ENV DEBIAN_FRONTEND noninteractive

##########################
# system update
RUN apt-get update -qq
RUN apt-get upgrade -qq -y
##########################

RUN apt-get install -qq -y python2.7 python-pip

## pypiserver installation
RUN pip install pypiserver
RUN pip install passlib
######


##########################
RUN useradd -d /home/pypiserver -m pypiserver
##########################


RUN mkdir -p /data/packages
RUN chown -R pypiserver /data/packages

VOLUME ["/data/packages"]


EXPOSE 8080

# Fix empty $HOME
ENV HOME /home/pypiserver
USER pypiserver

RUN mkdir -p /home/pypiserver/config/
ADD htaccess /home/pypiserver/config/.htaccess

WORKDIR /home/pypiserver
CMD ["pypi-server" , "-p", "8080", "-P", "/home/pypiserver/config/.htaccess", "/data/packages"]

