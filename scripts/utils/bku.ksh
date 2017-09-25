#!/usr/bin/ksh
# vim: ts=2:sw=2 sts=2:expandtab:
# bku.ksh
# Author: Douglas S. Elder
# Date: 5/4/15
# Desc: copy a file to a bku dir
# and prefix its name with its
# last modified date
# (a simple way to keep various
# versions of a file


if [ ! -e bku ] ; then
  mkdir bku
fi

if [ -e bku -a -d bku ] ; then
  cp $1 bku/.
  cd bku
  dateprefixfile -n
  cd ..
fi

echo $1 backed up to directory bku

