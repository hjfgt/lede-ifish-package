#!/bin/bash

./scripts/feeds update -a
./scripts/feeds install -a -f

make download -j$(($(nproc) + 1))

make -j1 V=s