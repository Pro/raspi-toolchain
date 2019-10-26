#!/usr/bin/env bash

docker build -f Dockerfile --network=host -t gcc9-rpi-zero .
CONTAINER_ID=$(docker create gcc9-rpi-zero)
docker cp $CONTAINER_ID:/opt/cross-pi-gcc ./cross-pi-gcc

echo "Copying toolchain files to $BUILD_ARTIFACTSTAGINGDIRECTORY"

tar -pczf raspi-toolchain.tar.gz ./cross-pi-gcc
cp raspi-toolchain.tar.gz $BUILD_ARTIFACTSTAGINGDIRECTORY/