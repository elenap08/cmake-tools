#********************************************************************
#        _       _         _
#  _ __ | |_  _ | |  __ _ | |__   ___
# | '__|| __|(_)| | / _` || '_ \ / __|
# | |   | |_  _ | || (_| || |_) |\__ \
# |_|    \__|(_)|_| \__,_||_.__/ |___/
#
# www.rt-labs.com
# Copyright 2017 rt-labs AB, Sweden.
#
# This software is licensed under the terms of the BSD 3-clause
# license. See the file LICENSE distributed with this software for
# full license information.
#*******************************************************************/

include_guard()

# The name of the target operating system
set(CMAKE_SYSTEM_NAME rt-kernel)

# Default toolchain search path
if (NOT DEFINED ENV{COMPILERS})
  set(ENV{COMPILERS} "/opt/rt-tools/compilers")
endif()

# Get environment variables
set(RTK $ENV{RTK} CACHE STRING
  "Location of rt-kernel tree")
set(COMPILERS $ENV{COMPILERS} CACHE STRING
  "Location of compiler toolchain")
set(BSP $ENV{BSP} CACHE STRING
  "The name of the BSP to build for")

# Check that bsp.mk exists
set(BSP_MK_FILE ${RTK}/bsp/${BSP}/${BSP}.mk)
if (NOT EXISTS ${BSP_MK_FILE})
  message(FATAL_ERROR "Failed to open ${BSP_MK_FILE}")
endif()

# Slurp bsp.mk contents
file(READ ${BSP_MK_FILE} BSP_MK)

# Get CPU
string(REGEX MATCH "CPU=([A-Za-z0-9_\-]*)" _ ${BSP_MK})
set(CPU ${CMAKE_MATCH_1} CACHE STRING "")

# Get ARCH
string(REGEX MATCH "ARCH=([A-Za-z0-9_\-]*)" _ ${BSP_MK})
set(ARCH ${CMAKE_MATCH_1} CACHE STRING "")

# Get VARIANT
string(REGEX MATCH "VARIANT=([A-Za-z0-9_\-]*)" _ ${BSP_MK})
set(VARIANT ${CMAKE_MATCH_1} CACHE STRING "")

# Get CROSS_GCC
string(REGEX MATCH "CROSS_GCC=([A-Za-z0-9_\-]*)" _ ${BSP_MK})
set(CROSS_GCC ${CMAKE_MATCH_1} CACHE STRING "")

# Set cross-compiler toolchain
set(CMAKE_C_COMPILER ${COMPILERS}/${CROSS_GCC}/bin/${CROSS_GCC}-gcc)
set(CMAKE_CXX_COMPILER ${CMAKE_C_COMPILER})

# Set cross-compiler machine-specific flags
include(toolchain/${CPU})
