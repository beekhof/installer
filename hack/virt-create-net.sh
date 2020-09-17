#!/bin/bash

# https://fedoramagazine.org/using-the-networkmanagers-dnsmasq-plugin/

virsh net-destroy test-net
virsh net-create ./hack/net.xml

echo server=/api.test-cluster.redhat.com/192.168.126.1 > /etc/NetworkManager/dnsmasq.d/aio.conf
echo -e "[main]\ndns=dnsmasq" > /etc/NetworkManager/conf.d/aio.conf
systemctl reload NetworkManager.service
