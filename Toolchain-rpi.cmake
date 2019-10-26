############################################################################
# toolchain-raspberry.cmake
# Copyright (C) 2014  Belledonne Communications, Grenoble France
#
############################################################################
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
############################################################################

# Source:
# https://gitlab.linphone.org/BC/public/linphone-cmake-builder/blob/master/toolchains/toolchain-raspberry.cmake

if("$ENV{RASPBERRY_VERSION}" STREQUAL "")
	set(RASPBERRY_VERSION 1)
else()
	if($ENV{RASPBERRY_VERSION} VERSION_GREATER 3)
		set(RASPBERRY_VERSION 3)
	else()
		set(RASPBERRY_VERSION $ENV{RASPBERRY_VERSION})
	endif()
endif()

if("$ENV{RASPBIAN_ROOTFS}" STREQUAL "")
	message(FATAL_ERROR "Define the RASPBIAN_ROOTFS environment variable to point to the raspbian rootfs.")
else()
	set(SYSROOT_PATH "$ENV{RASPBIAN_ROOTFS}")
endif()
set(TOOLCHAIN_HOST "arm-linux-gnueabihf")

message(STATUS "Using sysroot path: ${SYSROOT_PATH}")

set(TOOLCHAIN_CC "${TOOLCHAIN_HOST}-gcc")
set(TOOLCHAIN_CXX "${TOOLCHAIN_HOST}-g++")
set(TOOLCHAIN_LD "${TOOLCHAIN_HOST}-ld")
set(TOOLCHAIN_AR "${TOOLCHAIN_HOST}-ar")
set(TOOLCHAIN_RANLIB "${TOOLCHAIN_HOST}-ranlib")
set(TOOLCHAIN_STRIP "${TOOLCHAIN_HOST}-strip")
set(TOOLCHAIN_NM "${TOOLCHAIN_HOST}-nm")

set(CMAKE_CROSSCOMPILING TRUE)
set(CMAKE_SYSROOT "${SYSROOT_PATH}")

# Define name of the target system
set(CMAKE_SYSTEM_NAME "Linux")
if(RASPBERRY_VERSION VERSION_GREATER 1)
	set(CMAKE_SYSTEM_PROCESSOR "armv7")
else()
	set(CMAKE_SYSTEM_PROCESSOR "arm")
endif()

# Define the compiler
set(CMAKE_C_COMPILER ${TOOLCHAIN_CC})
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_CXX})
if(RASPBERRY_VERSION VERSION_GREATER 2)
# -march=armv7 -mcpu=cortex-a53 -mfpu=neon-vfpv4 -mfloat-abi=hard -marm
	set(CMAKE_C_FLAGS "-mcpu=cortex-a53 -mfpu=neon-vfpv4 -mfloat-abi=hard" CACHE STRING "Flags for Raspberry PI 3")
	set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "Flags for Raspberry PI 3")
elseif(RASPBERRY_VERSION VERSION_GREATER 1)

# -march=armv7 -mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard -marm
	set(CMAKE_C_FLAGS "-mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard" CACHE STRING "Flags for Raspberry PI 2")
	set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "Flags for Raspberry PI 2")
else()
	set(CMAKE_C_FLAGS "-march=armv6 -mcpu=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard -marm" CACHE STRING "Flags for Raspberry PI 1 B+ Zero")
	set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "Flags for Raspberry PI 1 B+ Zero")
endif()


set(CMAKE_FIND_ROOT_PATH "${CMAKE_INSTALL_PREFIX}" "${CMAKE_SYSROOT}")

# search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

