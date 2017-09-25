#!/usr/bin/ksh
# vim: ts=2:sw=2 sts=2:expandtab:
# whatisrunning.ksh
# Author: Douglas S. Elder
# Date: 4/28/15

if [ "$1" != "" ] ; then
  ACCT=$1
else
  ACCT=$LOGNAME
fi

ps -elf | grep $ACCT
