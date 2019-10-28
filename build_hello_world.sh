#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ ! -d $DIR/build ]; then
	mkdir $DIR/build
fi
cd $DIR/build

# To get the rootfs which is required here, use:
# rsync -rl --delete-after --safe-links pi@192.168.1.PI:/{lib,usr} $HOME/rpi/rootfs

export RASPBIAN_ROOTFS=$HOME/rpi/rootfs
export PATH=/opt/cross-pi-gcc/bin:/opt/cross-pi-gcc/libexec/gcc/arm-linux-gnueabihf/8.3.0:$PATH
export RASPBERRY_VERSION=1

cmake -DCMAKE_TOOLCHAIN_FILE=$DIR/Toolchain-rpi.cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo $DIR/hello_world
make -j
