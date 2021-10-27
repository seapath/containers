<!--
Copyright (C) 2021, RTE (http://www.rte-france.com
SPDX-License-Identifier: CC-BY-4.0
-->

# How to test the PXE docker image

The PXE docker image is intended to be launched by docker-compose. It is
however possible to launch it in standalone mode to test.

To do so, follow these steps:
* generate with Yocto the *seapath-flash-pxe* image
* create in the current folder the *images* folder
* copy the files *bzImage* and *seapath-flash-pxe-votp.cpio.gz* to the *images* folder
* build the PXE image with docker:
    `docker build . \
        --tag pxe \
        --build-arg DHCP_RANGE_BEGIN=192.168.111.50 \
        --build-arg DHCP_RANGE_END=192.168.111.100 \
        --build-arg DHCP_BIND_INTERFACE=eth0`
* connect the PC to the PXE network
* run the PXE container:
  `docker run \
            --rm \
            -it \
            -v $(pwd)/images:/tftpboot/images \
            --cap-add NET_ADMIN \
            --net host pxe`
* start the machine you want to boot
* at the end you should have access to a login prompt

DHCP_BIND_INTERFACE must be changed to the network interface you want to use for
PXE. No DHCP server should be present in this interface.

`DHCP_RANGE_BEGIN` and `DHCP_RANGE_END` must be changed according to your
network configuration. All the range must be in the same subnet as your PC IP.
