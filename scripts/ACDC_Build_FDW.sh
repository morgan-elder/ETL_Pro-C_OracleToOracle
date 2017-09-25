#!/bin/sh


if (($#>0)) ; then
  RECIPIENTS=$1
else
  if [ `logname` = "zf297a" ] ; then
    RECIPIENTS=douglas.s.elder@boeing.com
  else
    RECIPIENTS=jamees.i.keller@boeing.com
  fi
fi

. /mcair/rel/appl/pss_shared/public/set_pss_env_no_login
. /data/scm/public/setup_scm_sh

#export TWO_TASK=stl_prodsup01

set -o pipefail

current_time=$(date "+%Y_%m_%d_%H_%M_%S")
SYSOUT=/tmp/${current_time}_ACDC_FDW_out.txt
{
  echo "----------------------------------------------------------------"
  echo "--- Build ACDC FDW Data Tables `date`                     -----"
  echo "---          ACDC_Build_FDW.sh                              -----"
  echo "----------------------------------------------------------------"

  echo "Command being executed - "$0
  echo "Arguments being Passed - "$*
  echo "Number of Arguments "$#
  echo "PSS_DB  "$PSS_DB
  echo "PSS_ENV  "$PSS_ENV
  echo "HOSTNAME "`hostname`

  echo "TWO_TASK "$TWO_TASK
  export scm_sql=$scm_home/sql
  PARMFILE=$scm_home/load;export PARMFILE
  scm_exe=$scm_home/c/exe

  if [ $PSS_ENV = "PRODN" ]
     then
      echo "Processing Production" $PSS_ENV
      export dta_scm=$dta_scm/PROD
  else
      echo "Processing Test" $PSS_ENV
      export dta_scm=$dta_scm/TEST
  fi


  echo "Data Directory $dta_scm"
  echo "SQL Directory $scm_sql"

  rc=0

  SQLFILE=$scm_sql/.ACDC_FDW_sqlfile.sql

  echo "#----------------------------------------------------------------------------------------#"
  echo "#------------ Extract FDW Data `date`                     -------------------------------#"
  echo "#----------------------------------------------------------------------------------------#"
  echo "#----------------------------------------------------------------------------------------#"
  echo "#------------ Extract FDW Data `date`                     -------------------------------#"
  echo "#----------------------------------------------------------------------------------------#"
  SCHEMA=`cat $ORALOGIN/.FDW_destn`
  ACCESS=`cat $ORALOGIN/.FDW_pass`
  CONNECT=$FDWSRV
  ACDC_EXTRACTED_DATA=$dta_scm/ACDC_FDW_Extracted_Data.txt
  echo "Extracted ACDC Parts "$ACDC_EXTRACTED_DATA
  echo "Extracted ACDC Parts "$ACDC_EXTRACTED_DATA

  echo "--- Start of Pull for ACDC FDW Data`date`         -----"
  sqlplus -L ${SCHEMA}@${CONNECT}/${ACCESS} @$scm_sql/ACDC_PULL_FDW_DATA.sql $ACDC_EXTRACTED_DATA
  rc=$?
  if [ $rc -ne 0 ]
     then
    rc=100
    echo "*******************************************************************************"
    echo "***      Abnormal Termination of SQL Pull FDW Data `date`                   ***"
    echo "*******************************************************************************"
    echo "*******************************************************************************"
    echo "***      Abnormal Termination of SQL Pull FDW Data `date`                   ***"
    echo "*******************************************************************************"
    more $ACDC_EXTRACTED_DATA
  else
    echo "*******************************************************************************"
    echo "***      Successful Completion of SQL Pull FDW Data `date`                  ***"
    echo "*******************************************************************************"
    echo "*******************************************************************************"
    echo "***      Successful Completion of SQL Pull FDW Data `date`                  ***"
    echo "*******************************************************************************"
    recs=$(wc -l < $ACDC_EXTRACTED_DATA)
    if [ $recs -eq 0 ] ; then
      echo "No FDW Data was found"
    fi
  fi

  echo $TWO_TASK
  if [ $rc -eq 0 ]
    then
    #----------------------------------------------------------------------------------------#
    #------------ Load ACDC FDW Data `date`                   -------------------------------#
    #----------------------------------------------------------------------------------------#
    #----------------------------------------------------------------------------------------#
    #------------ Load ACDC FDW Data `date`                   -------------------------------#
    #----------------------------------------------------------------------------------------#
    DATAFILE=$ACDC_EXTRACTED_DATA;export DATAFILE 
    CTLFILE=$scm_home/load/ACDC_FDW_DTL_Data_load.ctl;export CTLFILE
    LOGFILE=$dta_scm/ACDC_FDW_Data.log;export LOGFILE
    BADFILE=$dta_scm/ACDC_FDW_Data.bad;export BADFILE
    DISCFILE=$dta_scm/ACDC_FDW_Data.dsc;export DISCFILE

    echo "Data File " $DATAFILE
    echo "Control File " $CTLFILE
    echo "Log File " $LOGFILE
    echo "Bad File " $BADFILE
    echo "Discard File " $DISCFILE
    echo "Oracle Data Base Version "$PSS_VRSN
    echo "Oracle SID "$PSS_ORACLE_SID
  # echo "Data Base Machine "$PSS_DB

    if [ -f $DATAFILE ]
    then
  #      remsh $PSS_DB -n "set batch
  #      export PSS_VRSN=$PSS_VRSN
  #      export PSS_ORACLE_SID=$PSS_ORACLE_SID

      export LOGFILE=$LOGFILE
      export BADFILE=$BADFILE 
      export DISCFILE=$DISCFILE 
      export DATAFILE=$DATAFILE 
      SCHEMA=`cat $ORALOGIN/.SCM_destn`
      ACCESS=`cat $ORALOGIN/.SCM_pass`
      CONNECT=$SLICSRV

      sqlldr ${SCHEMA}@${CONNECT}/${ACCESS} parfile=$PARMFILE/scm.par control=$CTLFILE, log=$LOGFILE
      rc=$?
      if [ $rc -eq 0 ]
      then
        echo "\r\t********************************"
        echo "\r\tSuccessful load of ACDC `date` "
        echo "\r\t********************************"
        echo "\r\t********************************"
        echo "\r\tSuccessful load of ACDC `date` "
        echo "\r\t********************************"
        rc=0
      else
        echo "\r\t********************************"
        echo "\r\tUnsuccessful load of ACDC `date` "
        echo "\r\t********************************"
        echo "\r\t????????????????????????????????"
        echo "\r\tUnsuccessful load of ACDC `date` "
        echo "\r\t????????????????????????????????"
        rc=20
      fi
      if [ -f $LOGFILE ] ; then
        cat $LOGFILE
      fi
    else
      echo "Unable to locate load file  `date`" $DATAFILE
      rc=21
    fi
  fi

  echo "#----------------------------------------------------------------------------------------#"
  echo "#------------ Create ACDC FDW Summed Data `date`          -------------------------------#"
  echo "#----------------------------------------------------------------------------------------#"
  echo "#----------------------------------------------------------------------------------------#"
  echo "#------------ Create ACDC FDW Summed Data `date`          -------------------------------#"
  echo "#----------------------------------------------------------------------------------------#"
  SCHEMA=`cat $ORALOGIN/.stlscm_DESTN`
  ACCESS=`cat $ORALOGIN/.stlscm_PASS`
  CONNECT=$SLICSRV

  echo "--- Start of Consolidate for ACDC FDW Data`date`         -----"
  sqlplus -L ${SCHEMA}@${CONNECT}/${ACCESS} @$scm_sql/ACDC_Consolidate_FDW.sql
  rc=$?
  if [ $rc -ne 0 ]
     then
    rc=100
    cat $SQLFILE
    echo "*******************************************************************************"
    echo "***      Abnormal Termination of SQL Consolidate FDW Data `date`            ***"
    echo "*******************************************************************************"
    echo "*******************************************************************************"
    echo "***      Abnormal Termination of SQL Consolidate FDW Data `date`            ***"
    echo "*******************************************************************************"
  else
    echo "*******************************************************************************"
    echo "***      Successful Completion of SQL Consolidate FDW Data `date`           ***"
    echo "*******************************************************************************"
    echo "*******************************************************************************"
    echo "***      Successful Completion of SQL Consolidate FDW Data `date`           ***"
    echo "*******************************************************************************"
  fi


  echo "---------------------------------------------------------------------------"
  echo "--- ACDC Build FDW Data Tables Completion `date`                      -----"
  echo "--- Return Code " $rc
  echo "---------------------------------------------------------------------------"
  echo "---------------------------------------------------------------------------"
  echo "--- ACDC Build FDW Data Tables Completion `date`                      -----"
  echo "--- Return Code " $rc
  echo "---------------------------------------------------------------------------"

} 2>&1 | tee -a $SYSOUT
rc=$?

if [ $rc -eq 0 ]
   then
  echo -e "From: ACDC_Build_FDW Script\nSubject: Successful Completion ACDC Build FDW Data Tables\nTo: ${RECIPIENTS}" | more $SYSOUT | sed '/^~/s/~//' | sendmail -t
else
  echo -e "From: ACDC_Build_FDW Script\nSubject: Abnormal Termination ACDC Build FDW Data Tables\nTo: ${RECIPIENTS}" | more $SYSOUT | sed '/^~/s/~//' | sendmail -t
fi
chmod 660 $SYSOUT
exit $rc
