# raspberry-crosscompile-gcc9

Repository for Raspberry PI cross compiler using the new GCC9 for Raspbian Buster.
This supports all new Raspberry PIs (ARMv7), and the older ones, including Zero, A, B, B+ (ARMv6) with newer GCCs.

By default, newer GCC versions do not create correct binaries for ARMv6.
Running them on your RasPI Zero will cause an "Illegal Instruction" exception.
See also:
https://stackoverflow.com/questions/55465118/gcc-8-cross-compiler-outputs-armv7-executable-instead-of-armv6

This work is based on the great @tttapa and the Docker file here:
https://gist.github.com/tttapa/534fb671c5f6cced0e1722d3e4aec987

A corresponding Blog post can be found here:
https://solarianprogrammer.com/2018/05/06/building-gcc-cross-compiler-raspberry-pi/


A similar project can also be found here:
https://sourceforge.net/projects/raspberry-pi-cross-compilers

## How to get the toolchain

You have two options:

- Use the prebuilt toolchain attached to every github release (recommended)
- Build the toolchain yourself

### Use pre-built toolchain

Every github release has a pre-build toolchain attached.
See

1. Download the toolchain:
```bash
wget https://github.com/Pro/raspi-toolchain/releases/latest/download/raspi-toolchain.tar.gz
```
2. Extract it. Note: The toolchain has to be in `/opt/cross-pi-gcc` since it's not location independent.
```bash
sudo tar xfz raspi-toolchain.tar.gz --strip-components=1 -C /opt
```
3. You are done!

### Build the toolchain from source

To build the toolchain, just clone this repository and then call:

```bash
docker build -f Dockerfile --network=host -t gcc9-rpi-zero .
```

This will take some time since it builds a docker container with the gcc compiler.

To run the docker container, use

```bash
docker run -it gcc9-rpi-zero bash
```

### Install from source after building

To get the toolchain from the docker container into your host, just copy the files:

```bash
CONTAINER_ID=$(docker create gcc9-rpi-zero)
sudo docker cp $CONTAINER_ID:/opt/cross-pi-gcc /opt/cross-pi-gcc
```

It's important that you put the files into the same directory, since the toolchain has the paths hardcoded inside.

After that feel free to delete the docker container.

## Test the toolchain

This repository contains a simple hello world example.

To cross-compile any executable after you installed the toolchain on your host,
you need to get the current libraries and include files from your raspberry:

```bash
# Use the correct IP address here
rsync -rl --delete-after --safe-links pi@192.168.1.PI:/{lib,usr} $HOME/rpi/rootfs
```

Then call the script `build_hello_world.sh`.

To test the executable, copy it to your raspi:

```bash
scp build/hello pi@192.168.1.PI:/home/pi/hello
ssh pi@192.168.1.PI
./hello
```
