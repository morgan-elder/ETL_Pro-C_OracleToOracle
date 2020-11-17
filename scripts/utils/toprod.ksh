#!/bin/ksh
# toprod.ksh
# Author: Douglas S. Elder
# Date: 12/15/2019
# Desc: Copy executable to the production
# server
# Rev 1.0   12/15/2019  Douglas S. Elder   Initial Rev
#
THIS=$(basename $0)
DATA=$HOME/data
if [[ -f $DATA/debug.txt ]] ; then
  DEBUG=$(cat $DATA/debug.txt)
else
  DEBUG=N
fi
[[ "$DEBUG" == "Y" ]] && set -x
EXE_HOME=$HOME/exe
SRC_DIR=$EXE_HOME
PROD_SVR=nwlsap06.cs.boeing.com
EXE_DIR=/data/gmics/db2m/prov/c
if (($#<=0)) ; then
  >&2 echo
  >&2 echo "Usage: $THIS exe_file"
  >&2 echo "where exe_file is the executable in $SRC_HOME"
  >&2 echo
  exit 4
fi
APP=$(basename $1)
APP=$(echo $APP | cut -f 1 -d '.')
RC=0
if [[ -f $SRC_DIR/$APP ]] ; then
  if [[ -x $SRC_DIR/$APP ]] ; then
    # delete the app first
    ssh -q slic2gld@${PROD_SVR} rm -f ${EXE_DIR}/$APP
    # now copy it to the server
    scp -pBv $SRC_DIR/$APP slic2gld@${PROD_SVR}:${EXE_DIR}/$APP
    RC=$?
    if ((RC==0)) ; then
      echo "$SRC_DIR/$APP copied to $PROD_SVR:$EXE_DIR/$APP"
    else
      echo "$SRC_DIR/$APP was NOT copied to $ROD_SVR:$EXE_DIR/$FILENAME"
    fi
  else
    echo $SRC_DIR/$APP is not an executable file
    RC=4
  fi
else
  echo $SRC_HOME/$APP does not exist
  RC=8
fi
exit $RC
