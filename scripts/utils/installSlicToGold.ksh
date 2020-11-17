#!/usr/bin/ksh


if (($#==0)) ; then
  SFTPSCRIPT=sftpSlicToGoldExe.txt
fi


cd /mcair/dev/appl/scm/c/exe
sftp -b ${SFTPSCRIPT} svappl16:/data/scm/c/exe
