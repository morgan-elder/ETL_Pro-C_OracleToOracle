#!/usr/bin/ksh
# vim: ts=2:sw=2 sts=2:expandtab:
# buildDir.ksh
# Author: Douglas S. Elder
# Date: 9/22/14
# Desc: Complile and link all the exe's
# in the specified directory
# the parameter must be the name of the directory
# containing the exe's to be compiled

cd $1
cur_dir=`pwd`
for file in * 
do
  cd $SOURCE_HOME/$file
  myCompileLink.ksh $file
  cp $file $cur_dir/.
done

