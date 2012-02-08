#!/bin/sh
#
#   Bindle Binaries Objective-C Kit
#   Copyright (c) 2012, Bindle Binaries
#
#   @BINDLE_BINARIES_BSD_LICENSE_START@
#
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions are
#   met:
#
#      * Redistributions of source code must retain the above copyright
#        notice, this list of conditions and the following disclaimer.
#      * Redistributions in binary form must reproduce the above copyright
#        notice, this list of conditions and the following disclaimer in the
#        documentation and/or other materials provided with the distribution.
#      * Neither the name of Bindle Binaries nor the
#        names of its contributors may be used to endorse or promote products
#        derived from this software without specific prior written permission.
#
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
#   IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
#   THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
#   PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL BINDLE BINARIES BE LIABLE FOR
#   ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
#   DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
#   SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
#   CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
#   LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
#   OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
#   SUCH DAMAGE.
#
#   @BINDLE_BINARIES_BSD_LICENSE_END@
#
#   build-aux/git-package-version.sh - determines Git version if available
#

# saves srcdir from command line arguments
if test "x${1}" == "x";then
   echo "Usage: ${0} srcdir [ savedir ]" 1>&2;
   exit 1;
fi;
SRCDIR=$1;

# saves savedir from command line arguments
OUTDIR="${SRCDIR}/build-aux"
if test "x${2}" != "x";then
   OUTDIR="${2}"
   if test ! -d "${OUTDIR}";then
      echo "${0}: ${OUTDIR}: directory does not exist" 1>&2;
      exit 1;
   fi
fi;

GPV="" # git project version (XXX.YYY.ZZZ.gCCC)
GBV="" # git build version (gCCC)
GAV="" # git application version (XXX.YYY.ZZZ)

# set default file names
if test "x${GIT_VERSION_FILE}" == "x";then
   GIT_VERSION_FILE="${OUTDIR}/git-package-version.txt"
fi
if test "x${GIT_VERSION_HEADER}" == "x";then
   GIT_VERSION_HEADER="${OUTDIR}/git-package-version.h"
fi
if test "x${GIT_VERSION_PREFIX_HEADER}" == "x";then
   GIT_VERSION_PREFIX_HEADER="${OUTDIR}/git-package-version-prefix.h"
fi

# sets default directories
GIT_VERSION_FILE_DIR=`dirname ${GIT_VERSION_FILE}`
GIT_VERSION_HEADER_DIR=`dirname ${GIT_VERSION_HEADER}`
GIT_VERSION_PREFIX_HEADER_DIR=`dirname ${GIT_VERSION_PREFIX_HEADER}`

if test -f ${SRCDIR}/.git/config;then
   # retrieve raw output of git describe
   RAW=`git --git-dir=${SRCDIR}/.git describe --long --abbrev=7 HEAD 2> /dev/null`;

   # calculate GBV from raw output of git describe
   GBV=`echo ${RAW} |cut -d- -f3`;

   # calculate GPV from raw output of git describe
   GPV=`echo ${RAW} |sed -e 's/-/./g'`;
   GPV=`echo ${GPV} |sed -e 's/^v//g'`;

   # calculate GAV from GPV
   GAV=`echo ${GPV} |sed -e 's/\.g[[:xdigit:]]\{0,\}$//g'`;
   GAV=`echo ${GAV} |sed -e 's/.0$//g'`;

   # write data to file and display results
   if test "x${GPV}" != "x";then
      rm -f ${GIT_VERSION_FILE} ${GIT_VERSION_HEADER} ${GIT_VERSION_PREFIX_HEADER_DIR}

      # writes git version file
      if test -d ${GIT_VERSION_FILE_DIR};then
         echo "${GPV}" > ${GIT_VERSION_FILE};   2>&1
      fi

      # writes git version C header
      if test -d ${GIT_VERSION_HEADER_DIR};then
         echo "#define GIT_PACKAGE_VERSION     \"${GPV}\""  > ${GIT_VERSION_HEADER}; 2>&1
         echo "#define GIT_APPLICATION_VERSION \"${GAV}\"" >> ${GIT_VERSION_HEADER}; 2>&1
         echo "#define GIT_BUILD_VERSION       \"${GBV}\"" >> ${GIT_VERSION_HEADER}; 2>&1
      fi

      # writes git version Info.plist preprocessor prefix file
      if test -d ${GIT_VERSION_PREFIX_HEADER_DIR};then
         echo "#define GIT_PACKAGE_VERSION     ${GPV}"  > ${GIT_VERSION_PREFIX_HEADER}; 2>&1
         echo "#define GIT_APPLICATION_VERSION ${GAV}" >> ${GIT_VERSION_PREFIX_HEADER}; 2>&1
         echo "#define GIT_BUILD_VERSION       ${GBV}" >> ${GIT_VERSION_PREFIX_HEADER}; 2>&1
      fi

      # displays summary
      echo "Git Package Version:     ${GPV}";
      echo "Git Application Version: ${GAV}";
      echo "Git Build Version:       ${GBV}";
   fi;
fi

# end of script
