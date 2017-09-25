#!/bin/sh
# Rev 1.1 capture SYSOUT with braces and redirect to tee
#         and make sure pipefail is on so that last
#         non-zero return code to the left of the pipe
#         gets returned if it occurs
# Rev 1.2 add steps and getopt

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
  RECIPIENTS=$1
else
  if [ `logname` = "zf297a" ] ; then
    RECIPIENTS=douglas.s.elder@boeing.com
  else
    RECIPIENTS=joseph.t.conley@boeing.com
  fi
fi


. /mcair/rel/appl/pss_shared/public/set_pss_env_no_login
. /data/scm/public/setup_scm_sh

set -o pipefail

current_time=$(date "+%Y_%m_%d_%H_%M_%S")
SYSOUT=/tmp/${current_time}_ACDC_Repair_Load_out.txt
rc=0

setup() {
  echo "----------------------------------------------------------------"
  echo "--- Build ACDC Load Repairs Table`date`                     -----"
  echo "---          ACDC_Load_Repairs_Data.sh                        -----"
  echo "----------------------------------------------------------------"

  echo "Command being executed - "$0
  echo "Arguments being Passed - "$*
  echo "Number of Arguments "$#
  echo "PSS_DB  "$PSS_DB
  echo "PSS_ENV  "$PSS_ENV
  echo "HOSTNAME "`hostname`
  scm_sql=$scm_home/sql
  PARMFILE=$scm_home/load;export PARMFILE
  scm_exe=$scm_home/c/exe

  echo "TWO_TASK "$TWO_TASK

  if [ $PSS_ENV = "PRODN" ]
     then
      export dta_scm=$dta_scm/PROD
  else
      export dta_scm=$dta_scm/TEST
  fi



  if [ $PSS_ENV = "TEST" ]
      then
      echo "Processing Test" $PSS_ENV
  else
      echo "Processing Production" $PSS_ENV
  fi


  echo "Data Directory " $dta_scm
  echo "SQL FILE "$scm_sql

  rc=0

}

extractRepairCost() {
  echo "#----------------------------------------------------------------------------------------#"
  echo "#------------ Extract Repair Cost from COPPR/GOLD `date` --------------------------------#"
  echo "#----------------------------------------------------------------------------------------#"
  SCHEMA=`cat $ORALOGIN/.stlscm_DESTN`
  ACCESS=`cat $ORALOGIN/.stlscm_PASS`
  CONNECT=$SLICSRV
  ACDC_EXTRACTED_PARTS=$dta_scm/ACDC_Repair_Costs_Extracted_Parts.txt
  ACDC_EXTRACTED_PARTS_NO_DUP=$dta_scm/ACDC_Repair_Costs_Extracted_Parts_No_Dup.txt
  rm -f $ACDC_EXTRACTED_PARTS
  echo "Extracted ACDC Parts "$ACDC_EXTRACTED_PARTS

  sqlplus -L ${SCHEMA}@${CONNECT}/${ACCESS}  @$scm_sql/ACDC_Extract_Repair_Cost.sql $ACDC_EXTRACTED_PARTS
  rc=$?
  if [ $rc -ne 0 ]
     then
    rc=100
    cat $SQLFILE
    cat $ACDC_EXTRACTED_PARTS
    echo "*******************************************************************************"
    echo "***      Abnormal Termination of SQL Pull Repair Costs `date`               ***"
    echo "*******************************************************************************"
  else
    wc -l $ACDC_EXTRACTED_PARTS
    awk '{ if (a[substr($0,61,50) substr($0,111,20) substr($0,131,20) substr($0,1,20) substr($0,21,20) substr($0,305,3)]++ == 0) print $0}' \
      $ACDC_EXTRACTED_PARTS > $ACDC_EXTRACTED_PARTS_NO_DUP
    rc=$?
    if [ $rc -eq 0 ] ; then
      echo "*******************************************************************************"
      echo "***      Successful Completion of SQL Pull Repair Costs `date`              ***"
      echo "*******************************************************************************"
    else
      echo "*******************************************************************************"
      echo "***      Abnormal Termination of awk no duplicates filter `date`            ***"
      echo "*******************************************************************************"
    fi
  fi
  return $rc
}

loadAcdcRepairCosts() {
    echo "----------------------------------------------------------------------------------------"
    echo "------------ Load ACDC Repair Costs `date`         -------------------------------------"
    echo "----------------------------------------------------------------------------------------"
    ACDC_EXTRACTED_PARTS_NO_DUP=$dta_scm/ACDC_Repair_Costs_Extracted_Parts_No_Dup.txt
    DATAFILE=$ACDC_EXTRACTED_PARTS_NO_DUP;export DATAFILE 
    CTLFILE=$scm_home/load/ACDC_Repair_Cost_load.ctl;export CTLFILE
    LOGFILE=$dta_scm/ACDC_Repairs.log;export LOGFILE
    BADFILE=$dta_scm/ACDC_Repairs.bad;export BADFILE
    DISCFILE=$dta_scm/ACDC_Repairs.dsc;export DISCFILE

    echo "Data File " $DATAFILE
    echo "Control File " $CTLFILE
    echo "Log File " $LOGFILE
    echo "Bad File " $BADFILE
    echo "Discard File " $DISCFILE
    echo "Oracle Data Base Version "$PSS_VRSN
    echo "Oracle SID "$PSS_ORACLE_SID
    echo "Data Base Machine "$PSS_DB
    SCHEMA=`cat $ORALOGIN/.SCM_destn`
    ACCESS=`cat $ORALOGIN/.SCM_pass`
    CONNECT=$SLICSRV
    

    if [ -f $DATAFILE ]
    then
      sqlldr ${SCHEMA}@${CONNECT}/${ACCESS} parfile=$PARMFILE/scm.par control=$CTLFILE, log=$LOGFILE
      rc=$?
      if [ $rc -eq 0 ]
      then
        cat $LOGFILE
        echo "\r\t********************************"
        echo "\r\tSuccessful load of ACDC  `date` "
        echo "\r\t********************************"
        rc=0
      else
        cat $LOGFILE
        echo "\r\t????????????????????????????????"
        echo "\r\tUnsuccessful load of ACDC `date` "
        echo "\r\t????????????????????????????????"
        rc=20
      fi
    else
      echo "Unable to locate load file  `date`" $DATAFILE
      rc=21
    fi
  return $rc
}

menu() {
  echo "0. extractRepairCost"
  echo "1. loadAcdcRepairCosts"
}

main() {
  if [ $stepnum -eq 0 ] ; then
    extractRepairCost
    rc=$?
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 1 ]
  then
    loadAcdcRepairCosts
    rc=$?
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 ]
    then
    echo "---------------------------------------------------------------------------"
    echo "--- ACDC Load Repair Tabless Completion `date`                        -----"
    echo "--- Return Code " $rc
    echo "---------------------------------------------------------------------------"
  fi
  return $rc
}

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

rc=$?

if [ "$STEP" = "menu" ] ; then
  exit 0
fi

if [ $rc -eq 0 ]
  then
  echo -e "From: ACDC_Load_Repairs_Data Script\nSubject: Successful Completion ACDC Load Repairs Cost Data\nTo: ${RECIPIENTS}" | more $SYSOUT | sed '/^~/s/~//' | sendmail -t

else
  echo -e "From: ACDC_Load_Repairs_Data Script\nSubject: Abnormal Termination ACDC Load Repairs Cost Data\nTo: ${RECIPIENTS}" | more $SYSOUT | sed '/^~/s/~//' | sendmail -t
fi
chmod 660 $SYSOUT
exit $rc
