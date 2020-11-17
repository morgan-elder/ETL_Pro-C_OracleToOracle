#!/usr/bin/ksh
# vim: ts=2:sw=2 sts=2:expandtab:
# copyExes.ksh
# Author: Douglas S. Elder
# Date: 9/9/14
# Desc: using a text file 
# with a list of filenames
# copy them to a specific directory
# 
# default txt files is slicexes.txt
# default target directory is $EXE_HOME
if (($# > 0)); then
  LIST=$1
else
  LIST=slicexes.txt
fi
if (($# > 1)); then
  TARGET=$2
else
  TARGET=$EXE_HOME      	
fi
for exe in $(cat $LIST)
do
	echo "Processing $exe"
	find . -name "$exe" -exec cp {} $TARGET/. \;
  echo "$exe copied to $TARGET"
done
