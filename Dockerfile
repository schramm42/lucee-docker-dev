FROM lucee/lucee52-nginx:latest

ENV HOME /root
ENV BIN_DIR /usr/local/bin

RUN apt-get update \
    && apt-get install -y \
    nano \
    unzip \
    procps \
    && rm -rf /var/lib/apt/lists/* \
    && echo "alias ll='ls -lA'" >> /root/.bashrc \
    && mkdir -p /etc/lucee/web \
    && mkdir -p /etc/lucee/server

COPY install.sh /install.sh
COPY default.conf /etc/nginx/conf.d/default.conf
COPY deny_lucee_admin.conf /etc/nginx/location.d/deny_lucee_admin.conf
COPY lucee-server.xml /opt/lucee/server/lucee-server/context/lucee-server.xml

COPY web.xml /usr/local/tomcat/conf/web.xml

RUN chmod +x /install.sh && /install.sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]