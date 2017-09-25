#!/bin/sh
# slicgldHG.sh
# Author: Douglas S. Elder
# Date: 4/25/2013
# Desc: execute app slicgldHG
# in a test environrment
echo "\n"

# set defaults
FILE_IN=f15_hg.dta
FILE_OUT=f15_hg_out.txt
set -x

while getopts "di:o:" o
do
  case "$o" in
    d) set -x;;
    i) FILE_IN=OPTARG;;
    o) FILE_OUT=OPTARG;;
    [?]) print >&2 "Usage $0 [-d] [-i file_in] [-o file_out]" 
      exit 1;;
  esac
done
shift $OPTIND-1

. /mcair/rel/appl/pss_shared/public/set_pss_env_no_login
rc=$?
if [ $rc -ne 0 ]
then
  echo "\n##############################################################" 
  echo "\nExit Code from set_common_env " $rc 
  echo "\nProcessing of SLIC/Gold Extract Program was not Successfully Completed - `date`" 
  echo "\n##############################################################" 
  errcode=500
  echo "SLIC/Gold Interface Exit Code " $errcode 
  exit $errcode
fi

#. /mcair/dev/appl/scm/public/setup_scm_sh
. /data/scm/public/setup_scm_sh

scm_public=/data/scm/public;export scm_public
scm_exe=/data/scm/c/exe;export scm_exe
echo "SCM_EXE "$scm_exe

PATH=$PATH:$scm_public:
export PATH
echo $scm_public

. $scm_public/setup_scm_sh
echo $scm_exe
echo $GOLDSRV
echo $SLICSRV

PROCESSING_MODEL="$1";export PROCESSING_MODEL

DOMAINNAME=`domainname`

echo $DOMAINNAME 
echo $PSS_ENV 

#
#  Setup output Datasets
#


echo "\n#*******************************************************************#" 
echo "* Start of SLIC/GOLD Extract - " `date` 
echo "* Processing Environment - " $PSS_ENV 
echo "#*******************************************************************#" 

if [ $PSS_ENV = "PRODN" ]
then
        DATA_DIR=/data/scm/PROD;export DATA_DIR
else
        DATA_DIR=/data/scm/TEST;export DATA_DIR
fi


echo "\n#*******************************************************************#" 
echo "#     Extract HG Change Activity - "`date` 
echo "#*******************************************************************#" 
echo "#" 
export TWO_TASK=stl_prodsup01

SLICGLD_HG=$PROCESSING_MODEL"_api_slicgld_hg.dta";export SLICGLD_HG
slicgldHG -a$FILE_IN -bF15 > $FILE_OUT
rc=$?
echo "Return Code = " $rc 
if [ $? -eq 0 ]
then
  echo "\n*************************************************************" 
  echo "* Successful completion of SLIC/Gold HG Change Activity Extract Program - `date`" 
  echo "*************************************************************" 
  errcode=0
else
  echo "\n##############################################################" 
  echo "# Unsuccessful completion of SLIC/Gold HG Change Activity Extract Program - `date`" 
  echo "##############################################################" 
  errcode=45
fi
cat $FILE_OUT | more
