# Pull base image
FROM resin/rpi-raspbian:buster

RUN apt update -y
RUN apt install -y wget
RUN wget -qO- https://repos.influxdata.com/influxdb.key | sudo apt-key add -
RUN echo "deb https://repos.influxdata.com/debian buster stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
RUN apt update -y
RUN apt install -y influxdb --no-install-recommends
RUN apt-get remove --auto-remove -y
RUN rm /etc/apt/sources.list.d/influxdb.list
RUN systemctl unmask influxdb
RUN systemctl enable influxdb

COPY influxdb.conf /etc/influxdb/influxdb.conf

ADD run.sh /run.sh
RUN chmod +x /*.sh

ENV PRE_CREATE_DB **None**

# HTTP API
EXPOSE 8086

VOLUME ["/data"]

CMD ["/run.sh"]

