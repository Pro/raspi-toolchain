#!/bin/bash


CONTAINER_ID=$(docker create gcc9-rpi-zero)
sudo docker cp $CONTAINER_ID:/opt/cross-pi-gcc /opt/cross-pi-gcc

