#!/bin/ksh
#compileAllandInstall.ksh
# Author: Douglas S. Elder
# Date: 06/16/2020
# Desc: Compile all the Pro*C apps
# in the pc directory and install them
# on the prod server

SRC=$HOME/src
cd $SRC
CURDIR=$(pwd)
cd share_routines
make
make build
cd $CURDIR
cd pc

for d in slic* btch* gld*
do
  CURDIR=$(pwd)
  cd $d
  touch *.pc
  make
  make install
  cd $CURDIR
done
