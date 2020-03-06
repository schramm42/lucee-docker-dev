FROM ubuntu:19.10

MAINTAINER Thomas Schramm <schramm42@gmail.com>
LABEL version="1.0"

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV TZ=Europe/Berlin
ENV HOME /root
ENV BIN_DIR /usr/local/bin
ENV JAVA_HOME /opt/lucee/jre

RUN apt-get update -y \
    && apt-get -y install \
    git \
    nano \
    curl \
    wget \
    unzip \
    supervisor \
    nginx \
    nginx-extras 

RUN \
	apt-get autoremove -y \
	&& apt-get clean -y \
	&& rm -rf /var/lib/apt/lists/* \
	# && rm -rf /etc/supervisor/* \
	&& rm -rf /etc/nginx/sites-enabled \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && echo "alias ll='ls -lA'" >> /root/.bashrc \
    && echo "export JAVA_HOME=/opt/lucee/jre" >> /root/.bashrc

RUN \
    cd /tmp \
    && wget https://cdn.lucee.org/lucee-5.3.4.080-pl0-linux-x64-installer.run \
    && chmod +x lucee-5.3.4.080-pl0-linux-x64-installer.run \
    && ./lucee-5.3.4.080-pl0-linux-x64-installer.run \
    --mode unattended \
    --luceepass lucee53 \
    --prefix /opt/lucee \
    --installconn false \
    --startatboot false \
    --systemuser root \
    && cp -rv /opt/lucee/tomcat/webapps/ROOT/* /var/www

COPY /etc/ /etc/
COPY server.xml /opt/lucee/tomcat/conf/

COPY install.sh /install.sh
RUN chmod +x /install.sh && /install.sh

EXPOSE 80

WORKDIR "/var/www"

# Start Supervisord
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# ENV HOME /root
# ENV BIN_DIR /usr/local/bin

# RUN apt-get update \
#     && apt-get install -y \
#     nano \
#     unzip \
#     procps \
#     && rm -rf /var/lib/apt/lists/* \
#     && echo "alias ll='ls -lA'" >> /root/.bashrc
#     && mkdir -p /etc/lucee/web \
#     && mkdir -p /etc/lucee/server

# COPY install.sh /install.sh
# COPY default.conf /etc/nginx/conf.d/default.conf
# COPY deny_lucee_admin.conf /etc/nginx/location.d/deny_lucee_admin.conf
# COPY lucee-server.xml /opt/lucee/server/lucee-server/context/lucee-server.xml

# COPY web.xml /usr/local/tomcat/conf/web.xml

# RUN chmod +x /install.sh && /install.sh

# COPY entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh

# ENTRYPOINT [ "/entrypoint.sh" ]