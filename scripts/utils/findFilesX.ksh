#!/usr/bin/ksh
# vim: ts=2:sw=2 sts=2:expandtab:
# findFiles.ksh
# Author: Douglas S. Elder
# Date: 9/9/14
# Desc: using a text file 
# with a list of filenames
# search form them
# starting at the current directory
# or the specified directory
# 
# default search directory is .
# default txt files is slicexes.txt
if (($# > 0)); then
  START=$1
else
  START=.
fi  
if (($# > 1)); then
  LIST=$2
else
  LIST=slicexes.txt
fi
if [[ ! -f $LIST ]] ; then
  echo $LIST does not exist
  exit 4
fi

for exe in $(cat $LIST)
do
  echo "Searching for $exe"
  find $START -name "$exe" | egrep ".*"
  if [ $? -ne 0 ] ; then
    echo $exe was not found
  fi
done
