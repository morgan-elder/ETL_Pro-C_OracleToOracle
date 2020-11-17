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
# default txt files is slicexes.txt
# default search directory is .
if (($# > 0)); then
  LIST=$1
else
  LIST=slicexes.txt
fi
if (($# > 1)); then
  START=$2
else
  START=.
fi  

for exe in $(cat $LIST)
do
  echo "Searching for $exe"
  find . -name "$exe" -print
done
