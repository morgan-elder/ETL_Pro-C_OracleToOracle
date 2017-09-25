#!/usr/bin/ksh
# vim: ts=2:sw=2 sts=2:expandtab:
# procLists.ksh
# Author: Douglas S. Elder
# Date: 9/9/14
# Desc: using a text file 
# with a set of list files 
# that contain a list of other filenames
# perform cmd on each list
# starting at the current directory
# or the specified directory
# 
# default search directory is .
# default txt files is slicfiles.tx
if (($# > 0)); then
  cmd=$1
else
  cmd=findFilesX.ksh
fi

if (($# > 1)); then
  START=$2
else
  START=.
fi  

if (($# > 2)); then
  LISTS=$3
else
  LISTS=$(ls *.txt)
  if [ $? -ne 0 ] ; then
    echo "No txt files found"
    exit 4
  fi
fi

for LIST in $LISTS
do
  echo "Processing list $LIST"
  for file in $(cat $LIST)
  do
    echo "Searching for $file"
    find $START -name "$file" -exec $cmd {} \;
  done
done
