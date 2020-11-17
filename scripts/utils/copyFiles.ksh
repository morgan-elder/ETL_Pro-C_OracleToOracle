#!/usr/bin/ksh
# vim: set ts=2 sw=2 sts=2 expandtab
# copyFiles:".ksh
# Author: Douglas S. Elder
# Date: 9/9/14
# Desc: using a text file 
# with a list of filenames
# copy them to a specific directory
# 
# default to searching in the current directory
# default txt files is slicfiles.txt
# default target directory is $file_HOME
# copyfiles.ksh ./work/c list.txt targetdir

if (($# > 0)); then
  START=$1
else
  START=.
fi  
if (($# > 1)); then
  LIST=$2
else
  LIST=slicfiles.txt
fi
if (($# > 2)); then
  TARGET=$3
else
  TARGET=$file_HOME      	
fi
for file in $(cat $LIST)
do
	echo "Processing $file"
	find $START -name "$file"  -exec cp {} $TARGET/. \;
  echo "$file copied to $TARGET"
done
