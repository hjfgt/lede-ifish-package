#!/bin/bash

sub=$(dirname $0)

cat $sub/conf/$1.config $sub/conf/base.config >.config