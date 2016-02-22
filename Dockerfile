FROM debian:wheezy
MAINTAINER Jean-Christophe Saad-Dupuy <jc.saaddupuy@fsfe.org>

ENV DEBIAN_FRONTEND noninteractive

##########################
# system update
##########################
RUN apt-get update -qq
RUN apt-get upgrade -qq -y
##########################

##########################
# python stuffs installation
RUN apt-get install -qq -y python2.7 python-pip
##########################

##########################
# pypiserver installation
##########################
RUN pip install pypiserver
RUN pip install passlib
##########################


##########################
RUN useradd -d /home/pypiserver -m pypiserver
##########################

##########################
# create the /data folder and symlink to the default folder
##########################
RUN mkdir -p /data/packages
RUN chown -R pypiserver /data/packages
RUN ln -s /data/packages /home/pypiserver/packages
RUN chown -R pypiserver /home/pypiserver/packages
##########################

##########################
# create the /config folder and symlink to the default folder
##########################
RUN mkdir -p /config
RUN chown -R pypiserver /data/packages
##########################

VOLUME ["/data/packages", "/config"]

##########################
# exposes the default port
##########################
EXPOSE 8080
##########################

# Fix empty $HOME
ENV HOME /home/pypiserver
USER pypiserver

ADD htaccess /config/.htaccess

WORKDIR /home/pypiserver

# Always starts with the .htaccess
ENTRYPOINT ["/usr/local/bin/pypi-server", "-P", "/config/.htaccess"]

# Hack : add a CMD with default value to enable passing other options
CMD ["-p", "8080"]

