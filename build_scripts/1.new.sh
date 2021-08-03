#!/bin/bash

./scripts/feeds update -a
./scripts/feeds install -a -f

bash ./feeds/lede_ifish/cpconfig.sh ax6
make defconfig
make download -j$(($(nproc) + 1))

sed -i 's/net.netfilter.nf_conntrack_max=.*/net.netfilter.nf_conntrack_max=65535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
sed -i 's/192.168.1.1/172.16.1.1/g' package/base-files/files/bin/config_generate

make -j1 V=s