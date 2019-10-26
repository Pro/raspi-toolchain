#!/bin/bash

CONTAINER_ID=$(docker ps -aqf "name=gcc9-rpi-zero")
docker cp $CONTAINER_ID:/opt/cross-pi-gcc /opt/cross-pi-gcc

