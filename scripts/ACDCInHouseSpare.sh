#!/bin/sh

usage() {
 echo >&2 "Usage: $0 [ -d -m -o filename -s step ] email_addr"
 echo >&2 "  -d turn on debug"
 echo >&2 "  -m show step menu"
 echo >&2 "  -n stepname where stepname is one of the steps in this script"
 echo >&2 "  -o SYSOUT filename"
 echo >&2 "  -s stepnum where stepnum is 0 to 23"
 echo >&2 "  email_addr - default is joseph.t.conley@boeing.com unless being executed by zf297a"
}

stepnum=0

while getopts dmn:o:s: o
do  case "$o" in
  d)  DEBUG=Y 
      DBGECHO=echo
      set -x ;;
  m)  STEP=menu ;;
  n)  STEP=$OPTARG ;;
  o)  SYSOUT=$OPTARG ;;
  s)  stepnum=$OPTARG ;;
[?])  usage
      exit 1;;
  esac
done
shift $(( $OPTIND - 1))


if (($#>0)) ; then
  RECIPIENTS=$1,
else
  if [ `logname` = "zf297a" ] ; then
    RECIPIENTS=douglas.s.elder@boeing.com
  else
    RECIPIENTS=joseph.t.conley@boeing.com
  fi
fi


. /mcair/rel/appl/pss_shared/public/set_pss_env_no_login
. /data/scm/public/setup_scm_sh

setup() {
  echo "----------------------------------------------------------------"
  echo "--- Build ACDC In House Spares Table `date`                     -----"
  echo "---          ACDCInHouseSpare.sh                              -----"
  echo "----------------------------------------------------------------"

  PARMFILE=$scm_home/load;export PARMFILE
  scm_sql=$scm_home/sql
  scm_exe=$scm_home/c/exe

  echo "two_task "$TWO_TASK

  if [ "$PSS_ENV" = "TEST" ]
  then
      echo "processing test" $PSS_ENV
      export dta_scm=$dta_scm/TEST
  else
      echo "processing production" $pss_env
      export dta_scm=$dta_scm/PROD
  fi


  echo "data directory " $dta_scm
  echo "sql file "$scm_sql

  echo "Data Directory " $dta_scm
  echo "SQL FILE "$scm_sql

  echo "Command being executed - "$0
  echo "Arguments being Passed - "$*
  echo "Number of Arguments "$#
  echo "PSS_DB  "$PSS_DB
  echo "PSS_ENV  "$PSS_ENV
  echo "HOSTNAME "`hostname`
  echo "TWO_TASK "$TWO_TASK

  rc=0

}

extractGoldPartOrder() {
  echo "#----------------------------------------------------------------------------------------#"
  echo "#------------ Extract Part/Order Info from Gold `date`    -------------------------------#"
  echo "#----------------------------------------------------------------------------------------#"
  SCHEMA=`cat $ORALOGIN/.SCM_LB_destn`
  ACCESS=`cat $ORALOGIN/.SCM_LB_pass`
  CONNECT=$SLICSRV
  ACDC_EXTRACTED_PARTS=$dta_scm/ACDCInHouseSpare_Extracted_Parts.txt
  echo "Extracted ACDC Parts "$ACDC_EXTRACTED_PARTS

  echo "--- Start of Pull for ACDC Part/Order Data `date`         -----"
  sqlplus -L ${SCHEMA}@${CONNECT}/${ACCESS} @$scm_sql/ACDCPullInHouseSpare.sql $ACDC_EXTRACTED_PARTS
  rc=$?
  if [ $rc -ne 0 ]
     then
    rc=100
    echo "*******************************************************************************"
    echo "***      Abnormal Termination of SQL Pull of Part/Order Info `date`         ***"
    echo "*******************************************************************************"
  else
    echo "*******************************************************************************"
    echo "***      Successful Completion of SQL Pull of Part/Order Info `date`         ***"
    echo "*******************************************************************************"
  fi

  return $rc

}


extractIMACpartInfo() {

  ACDC_EXTRACTED_PARTS=$dta_scm/ACDCInHouseSpare_Extracted_Parts.txt

  echo "#----------------------------------------------------------------------------------------#"
  echo "#------------ Extract Part Information from IMAC Table `date` --------------------------#"
  echo "#----------------------------------------------------------------------------------------#"
  ACDC_EXTRACTED_IMACS_PART_DATA=$dta_scm/ACDCInHouseSpare_IMAC_Parts.txt
  echo "Input Extracted ACDC Parts "$ACDC_EXTRACTED_PARTS
  echo "Output Extracted ACDC IMACS Info "$ACDC_EXTRACTED_IMACS_PART_DATA

  export TWO_TASK=$IMACSRV

  $scm_exe/ACDCIMAC_pull -a$ACDC_EXTRACTED_PARTS -b$ACDC_EXTRACTED_IMACS_PART_DATA
  rc=$?
  if [ $rc -eq 0 ]
    then
    echo "*******************************************************************************"
    echo "***      Sucessful Completion of IMACS Extract `date`                      ***"
    echo "*******************************************************************************"
  else
    rc=100
    echo "*******************************************************************************"
    echo "***      Abnormal Termination of IMACS Extract `date`                      ***"
    echo "*******************************************************************************"
  fi

  return $rc

}

updateSCMsparesTable() {

  ACDC_EXTRACTED_IMACS_PART_DATA=$dta_scm/ACDCInHouseSpare_IMAC_Parts.txt

  echo "#----------------------------------------------------------------------------------------#"
  echo "#------------ Update SCM In House Spares Table `date`     -------------------------------#"
  echo "#----------------------------------------------------------------------------------------#"
  ACDC_EXTRACTED_IMACS_PART_DATA_OUT=$dta_scm/ACDCInHouseSpare_Out_Data.txt
  echo "Input Extracted ACDC IMACS Info "$ACDC_EXTRACTED_IMACS_PART_DATA

  export TWO_TASK=$SLICSRV
  $scm_exe/ACDCIMAC_Update -a$ACDC_EXTRACTED_IMACS_PART_DATA 
  rc=$?
  if [ $rc -eq 0 ]
    then
    echo "*******************************************************************************"
    echo "***      Sucessful Completion of SCM In House Spares `date`                 ***"
    echo "*******************************************************************************"
  else
    rc=100
    echo "*******************************************************************************"
    echo "***      Abnormal Termination of SCM In House Spares `date`                 ***"
    echo "*******************************************************************************"
  fi

  return $rc
}

menu() {
  echo "0. extractGoldPartOrder"
  echo "1. extractIMACpartInfo"
  echo "2. updateSCMsparesTable"
}

main() {
  if [  $stepnum -eq 0 ] ; then
    extractGoldPartOrder
    rc=$?
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 1 ] ; then
    extractIMACpartInfo
    rc=$?
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 2 ] ; then
    updateSCMsparesTable
    rc=$?
    let stepnum=$stepnum+1
  fi

  echo "---------------------------------------------------------------------------"
  echo "--- ACDC Build In House Spare Information Completion `date`           -----"
  echo "--- Return Code " $rc
  echo "---------------------------------------------------------------------------"

}

SYSOUT=/tmp/ACDCInHouseSpare_out.txt
{

  setup

  if [ "$STEP" = "menu" ] ; then
    menu
  elif [ -n "$STEP" ] ; then
    $STEP ; [[ $? == 0 ]] || (echo "Step $STEP does not exist in this script" && usage)
  else  
    main
  fi

} 2>&1 | tee -a $SYSOUT

rc=$0

if [ "$STEP" = "menu" ] ; then
  exit 0
fi

if [ $rc -eq 0 ]
then
  echo -e "From: ACDCInHouseSpare.sh Script\nSubject: Successful Completion ACDC In House Spare Interface\nTo: ${RECIPIENTS}" | more $SYSOUT | sed '/^~/s/~//' | sendmail -t
else
  echo -e "From: ACDCInHouseSpare.sh Script\nSubject: Successful Completion ACDC In House Spare Interface\nTo: ${RECIPIENTS}" | more $SYSOUT | sed '/^~/s/~//' | sendmail -t
fi

chmod 770 $SYSOUT



exit $rc
