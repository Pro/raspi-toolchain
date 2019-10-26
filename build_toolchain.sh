#!/bin/bash

docker build -f Dockerfile --network=host -t gcc9-rpi-zero .
