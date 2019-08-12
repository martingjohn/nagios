FROM ubuntu:18.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
            apache2 \
            build-essential \
            libapache2-mod-php \
            libgd-dev \
            libssl-dev \
            openssl \
            php \
            php-gd \
            unzip \
            vim \
            wget

#    && rm -rf /var/lib/apt/lists/*

ENV NAGIOS_VERSION=4.4.4 \
    PLUGIN_VERSION=2.2.1

EXPOSE 80

RUN useradd nagios && \
    groupadd nagcmd && \
    usermod -a -G nagcmd nagios && \
    usermod -a -G nagcmd www-data

RUN cd /opt && \
    wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-${NAGIOS_VERSION}.tar.gz && \
    tar xzf nagios-${NAGIOS_VERSION}.tar.gz

RUN cd /opt/nagios-${NAGIOS_VERSION} && \
    ./configure --with-command-group=nagcmd && \
    make all && \
    make install && \
    make install-init && \
    make install-daemoninit && \
    make install-config && \
    make install-commandmode && \
    make install-exfoliation && \
    cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/ && \
    chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers

COPY nagios.conf /etc/apache2/sites-available/nagios.conf
RUN a2dissite 000-default && \
    a2ensite nagios && \
    a2enmod cgi rewrite

RUN htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin nagiosadmin

RUN cd /opt && \
    wget http://www.nagios-plugins.org/download/nagios-plugins-${PLUGIN_VERSION}.tar.gz && \
    tar xzf nagios-plugins-${PLUGIN_VERSION}.tar.gz && \
    cd nagios-plugins-${PLUGIN_VERSION}

RUN ./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl && \
    make && \
    make install

COPY entrypoint.sh /root

ENTRYPOINT ["/bin/bash"]
#CMD ["/root/entrypoint.sh"]


