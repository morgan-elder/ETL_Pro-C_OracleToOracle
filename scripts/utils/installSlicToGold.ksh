#!/usr/bin/ksh


if (($#=0)) ; then
  SFTPSCRIPT=sftpSlciToGoldExe.txt
fi


cd /mcair/dev/appl/scm/c/exe
sftp -b ${SFTPSCRIPT} svappl16:/data/scm/c/exe
