# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FROM alpine:3.13
ARG DHCP_RANGE_BEGIN=10.0.24.10
ARG DHCP_RANGE_END=10.0.24.200
ARG DHCP_BIND_INTERFACE=eth0

RUN apk --no-cache add dnsmasq syslinux
COPY dnsmasq.conf /etc/dnsmasq.conf
COPY dhcp_extra_config/* /etc/dnsmasq.d/
RUN echo "dhcp-range=${DHCP_RANGE_BEGIN},${DHCP_RANGE_END},48h" \
    > /etc/dnsmasq.more.conf
RUN echo "interface=${DHCP_BIND_INTERFACE}" >> /etc/dnsmasq.more.conf
VOLUME /tftpboot/images
CMD /usr/sbin/dnsmasq --keep-in-foreground --log-facility=-
