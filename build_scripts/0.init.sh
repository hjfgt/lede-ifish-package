#!/bin/bash

sudo apt-get update
sudo apt-get -y install build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch python3 python2.7 unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler g++-multilib antlr3 gperf wget curl swig rsync

git clone https://github.com/coolsnowwolf/lede
cd lede

cp feeds.conf.default feeds.conf
echo 'src-git lede_ifish https://github.com/iccfish/lede-ifish-package.git' >>feeds.conf.default