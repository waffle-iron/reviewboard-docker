FROM httpd:2.4.20
MAINTAINER Ovidiu-Florin Bogdan (ovidiu.b13@gmail.com)

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt install -y \
    patch \
    subversion \
    memcached \
    ca-certificates
RUN apt update && apt install -y \
    python-setuptools \
    python-dev \
    python-mysqldb \
    python-svn
RUN apt update && apt install -y \
    libjpeg-dev \
    zlib1g-dev \
    libffi-dev \
    libssl-dev

RUN easy_install -U setuptools
RUN easy_install pip
RUN pip install python-memcached
RUN pip install mysql-python

RUN apt-get install gcc -s | grep "Inst " | cut -f 2 -d " " > gcc-deps.txt
RUN apt install -y gcc

RUN pip install ReviewBoard
RUN pip install mod_wsgi

RUN apt remove -y `cat gcc-deps.txt | tr "\n" " "` && rm gcc-deps.txt

COPY entrypoint.sh /entrypoint.sh

EXPOSE 80

VOLUME /var/www

ENTRYPOINT ["/entrypoint.sh"]
