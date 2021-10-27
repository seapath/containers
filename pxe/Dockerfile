# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FROM alpine:3.13
ARG DHCP_RANGE_BEGIN=192.168.111.50
ARG DHCP_RANGE_END=192.168.111.100
ARG DHCP_BIND_INTERFACE=eth0
ARG TFTP_SERVER=192.168.111.1

RUN apk --no-cache add dnsmasq syslinux
RUN mkdir /tftpboot
RUN cp -r /usr/share/syslinux /tftpboot/
RUN ln -sf syslinux/pxelinux.0 /tftpboot/pxelinux.0
RUN chown -R nobody:nogroup /tftpboot
RUN mkdir /tftpboot/pxelinux.cfg
COPY syslinux.cfg /tftpboot/pxelinux.cfg/default
COPY dnsmasq.conf /etc/dnsmasq.conf
RUN sed -i "s/{{ tftp server address }}/${TFTP_SERVER}/" /etc/dnsmasq.conf
COPY pxe_extra_config/* /etc/dnsmasq.d/
RUN echo "dhcp-range=${DHCP_RANGE_BEGIN},${DHCP_RANGE_END},48h" \
    > /etc/dnsmasq.more.conf
RUN echo "interface=${DHCP_BIND_INTERFACE}" >> /etc/dnsmasq.more.conf
VOLUME /tftpboot/images
CMD /usr/sbin/dnsmasq --keep-in-foreground --log-facility=-
