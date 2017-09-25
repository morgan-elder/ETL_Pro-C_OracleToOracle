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

set -o pipefail


SYSOUT=/tmp/ACDCBestPrice_M_out.txt

setup() {
  echo "----------------------------------------------------------------"
  echo "--- Build ACDC Best Price Table `date`                     -----"
  echo "---          ACDCBestPrice.sh                              -----"
  echo "----------------------------------------------------------------"

  ####################################################################################
  #export TWO_TASK=stl_prodsup01
  ####################################################################################

  echo "Command being executed - "$0
  echo "Arguments being Passed - "$*
  echo "Number of Arguments "$#
  echo "PSS_DB  "$PSS_DB
  echo "PSS_ENV  "$PSS_ENV
  echo "HOSTNAME "`hostname`

  PARMFILE=$scm_home/load;export PARMFILE

  echo "TWO_TASK "$TWO_TASK

  if [ "$PSS_ENV" = "TEST" ]
  then
      echo "processing test" $PSS_ENV
      export dta_scm=$dta_scm/TEST
  else
      echo "processing production" $pss_env
      export dta_scm=$dta_scm/PROD
  fi


  echo "Data Directory " $dta_scm
  echo "SQL FILE "$scm_sql

  ####################################################################################
  FISCAL_PERIOD=FY11
  PROCESSING_MDL=AV8B
  ####################################################################################
  echo FISCAL_PERIOD - $FISCAL_PERIOD
  echo PROCESSING_MDL - $PROCESSING_MDL

  rc=0
}

extractPartMfgList() {
  SQLFILE=$scm_sql/.ACDCBestPrice_sqlfile.sql

  echo "#----------------------------------------------------------------------------------------#"
  echo "#------------ Extract Part/MFG Codes from ACDC Data Table `date` ------------------------#"
  echo "#----------------------------------------------------------------------------------------#"
  SCHEMA=`cat $ORALOGIN/.SCM_destn`
  ACCESS=`cat $ORALOGIN/.SCM_pass`
  CONNECT=$SLICSRV
  ACDC_EXTRACTED_PARTS=$dta_scm/ACDCBestPrice_Extracted_Parts_M.txt
  echo "Extracted ACDC Parts "$ACDC_EXTRACTED_PARTS

  sqlplus -L ${SCHEMA}@${CONNECTION}/${ACCESS}  @$scm_sql/ACDCBestPrice_get_parts_M.sql $ACDC_EXTRACTED_PARTS
  rc=$?
  if [ $rc -ne 0 ]
     then
    rc=100
    echo "*******************************************************************************"
    echo "***      Abnormal Termination of SQL Pull of Basic Part Info `date`         ***"
    echo "*******************************************************************************"
  else
    wc -l $ACDC_EXTRACTED_PARTS
    echo "*******************************************************************************"
    echo "***      Successful Completion of SQL Pull of Basic Part Info `date`        ***"
    echo "*******************************************************************************"
  fi
  return $rc
}

extractBestPrice() {
  if [ $rc -eq 0 ]
    then
    echo "#----------------------------------------------------------------------------------------#"
    echo "#------------ Extract Best Price from ACDC Data Table `date` ----------------------------#"
    echo "#----------------------------------------------------------------------------------------#"
    ACDC_EXTRACTED_BEST_PRICE_PARTS=$dta_scm/ACDCBestPrice_Parts_M.txt
    echo "Input Extracted ACDC Parts "$ACDC_EXTRACTED_PARTS
    echo "Output Extracted ACDC Best Price Parts "$ACDC_EXTRACTED_BEST_PRICE_PARTS

    $scm_exe/ACDCBestPriceM -a$ACDC_EXTRACTED_PARTS -b$ACDC_EXTRACTED_BEST_PRICE_PARTS -c$FISCAL_PERIOD
    rc=$?
    if [ $rc -eq 0 ]
      then
      wc -l $ACDC_EXTRACTED_BEST_PRICE_PARTS
     echo "*******************************************************************************"
      echo "***      Sucessful Completion of Extract Best Price Info `date`             ***"
      echo "*******************************************************************************"
    else
      rc=110
      echo "*******************************************************************************"
      echo "***      Abnormal Termination of Extract Best Price Info `date`             ***"
      echo "*******************************************************************************"
    fi
  fi
  return $rc
}

extractPBOM_NoOrderPart() {
  if [ $rc -eq 0 ]
    then
    echo "#----------------------------------------------------------------------------------------#"
    echo "#------------ Extract PBOM No Order Part `date`           -------------------------------#"
    echo "#----------------------------------------------------------------------------------------#"
    ACDC_EXTRACTED_NO_ORDER_PARTS=$dta_scm/ACDCBestPrice_NoOrder_Parts_M.txt
    echo "Output Extracted ACDC No Order Parts "$ACDC_EXTRACTED_NO_ORDER_PARTS

    $scm_exe/ACDCNoOrderPartsM -a$ACDC_EXTRACTED_NO_ORDER_PARTS -b$FISCAL_PERIOD -c$PROCESSING_MDL
    rc=$?
    if [ $rc -eq 0 ]
      then
      wc -l $ACDC_EXTRACTED_NO_ORDER_PARTS
      echo "*******************************************************************************"
      echo "***      Sucessful Completion of Extract No Ordered Parts `date`            ***"
      echo "*******************************************************************************"
    else
      rc=115
      echo "*******************************************************************************"
      echo "***      Abnormal Termination of Extract No Ordered Parts `date`            ***"
      echo "*******************************************************************************"
    fi
  fi
  return $rc
}

consolidateNoOrderAndBestPrice() {
  if [ $rc -eq 0 ]
    then
    echo "#----------------------------------------------------------------------------------------#"
    echo "#------------ Consolidate No Order and Best Price Data `date` ---------------------------#"
    echo "#----------------------------------------------------------------------------------------#"
    ACDC_CONSOLIDATED_BEST_PRICE_PARTS=$dta_scm/ACDCBestPrice_Consolidate_Priced_Parts_M.txt
    echo "Input Extracted ACDC No Order Parts "$ACDC_EXTRACTED_NO_ORDER_PARTS
    echo "Input Extracted ACDC Best Price Parts "$ACDC_EXTRACTED_BEST_PRICE_PARTS
    echo "Output Consolidated Pricing Record "$ACDC_CONSOLIDATED_BEST_PRICE_PARTS

    sort -o$ACDC_CONSOLIDATED_BEST_PRICE_PARTS $ACDC_EXTRACTED_BEST_PRICE_PARTS $ACDC_EXTRACTED_NO_ORDER_PARTS
    rc=$?
    if [ $rc -eq 0 ]
      then
      wc -l $ACDC_CONSOLIDATED_BEST_PRICE_PARTS
      echo "*******************************************************************************"
      echo "***      Sucessful Completion of Consolidate Pricing Records `date`         ***"
      echo "*******************************************************************************"
    else
      rc=120
      echo "*******************************************************************************"
      echo "***      Abnormal Termination of Consolidate Pricing Records `date`         ***"
      echo "*******************************************************************************"
    fi
  fi
  return $rc
}

loadACDCbestPricesPass1() {
  if [ $rc -eq 0 ]
    then
    echo "#----------------------------------------------------------------------------------------#"
    echo "#------------ Load ACDC Best Price Table Pass 1 `date`    -------------------------------#"
    echo "#----------------------------------------------------------------------------------------#"
    DATAFILE=$ACDC_CONSOLIDATED_BEST_PRICE_PARTS;export DATAFILE 
    CTLFILE=$scm_home/load/ACDC_Best_Price_multi.ctl;export CTLFILE
    LOGFILE=$dta_scm/acdc_best_price_M.log;export LOGFILE
    BADFILE=$dta_scm/acdc_best_price_M.bad;export BADFILE
    DISCFILE=$dta_scm/acdc_best_price_M.dsc;export DISCFILE

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
           echo "\r\t********************************"
           echo "\r\tSuccessful load of ACDC Best Prices Pass 1 `date`"
           echo "\r\t********************************"
           cat $LOGFILE
           rc=0
         else
           echo "\r\t????????????????????????????????"
           echo "\r\tUnsuccessful load of ACDC Best Prices Pass 1 `date`"
           echo "\r\t????????????????????????????????"
           rc=20
         fi
    else
      echo "Unable to locate load file " $DATAFILE
      rc=21
    fi
  fi
  return $rc

}

getGoldData() {
  if [ $rc -eq 0 ]
    then
    echo "#----------------------------------------------------------------------------------------#"
    echo "#------------ Extract Other Part/MFG Codes from Gold Data Table  `date` -----------------#"
    echo "#----------------------------------------------------------------------------------------#"
    SCHEMA=`cat $ORALOGIN/.SCM_LB_dest`
    ACCESS=`cat $ORALOGIN/.SCM_LB_pass`
    CONNECT=$SLICSRV
    ACDC_EXTRACTED_OTHER_PARTS=$dta_scm/ACDCBestPrice_Extracted_Other_Parts_M.txt
    ACDC_EXTRACTED_OTHER_PARTS_SORTED=$dta_scm/ACDC_Extracted_Other_Parts_Sorted_M.txt
    echo "Extracted Other ACDC Parts "$ACDC_EXTRACTED_OTHER_PARTS
    echo "Extracted Other ACDC Parts "$ACDC_EXTRACTED_OTHER_PARTS

    sqlplus -L ${SCHEMA}@${CONNECT}/${ACCESS} @$scm_sql/ACDCOtherPartsM.sql $ACDC_EXTRACTED_OTHER_PARTS
    rc=$?
    if [ $rc -ne 0 ]
    then
      rc=116
      echo "*******************************************************************************"
      echo "***      Abnormal Termination of SQL Pull of Basic Part Info `date`         ***"
      echo "*******************************************************************************"
    else
      echo "*******************************************************************************"
      echo "***      Successful Completion of SQL Pull of Basic Part Info `date`        ***"
      echo "*******************************************************************************"
      echo "*******************************************************************************"
      echo "***      Suppress Dupes in Other Part Extract `date`                        ***"
      echo "*******************************************************************************"
      wc -l $ACDC_EXTRACTED_OTHER_PARTS
      ACDC_EXTRACTED_OTHER_PARTS_SORTED=$dta_scm/ACDCBestPrice_Extracted_Other_Parts_Sorted_M.txt
      echo "Extracted Other ACDC Parts Sorted "$ACDC_EXTRACTED_OTHER_PARTS_SORTED
      sort -u -o$ACDC_EXTRACTED_OTHER_PARTS_SORTED $ACDC_EXTRACTED_OTHER_PARTS
      rc=$?
      if [ $rc -eq 0 ]
      then
        echo "*******************************************************************************"
        echo "***      Successful Completion of Extract of Other Parts `date`             ***"
        echo "*******************************************************************************"
        wc -l $ACDC_EXTRACTED_OTHER_PARTS_SORTED
      else
        rc=117
        echo "*******************************************************************************"
        echo "***      Abnormal Completion of Extract of Other Parts `date`               ***"
        echo "*******************************************************************************"
      fi
    fi
  fi

  return $rc
}

processOtherParts() {
  if [ $rc -eq 0 ]
    then
    echo "#----------------------------------------------------------------------------------------#"
    echo "#------------ Process ACDC Other Parts `date`             -------------------------------#"
    echo "#----------------------------------------------------------------------------------------#"
    ACDC_EXTRACTED_OTHER_SLIC_PRICED_PARTS=$dta_scm/ACDCBestPrice_Extracted_Other_Parts_SLIC_M.txt
    echo "Input Extracted ACDC Parts "$ACDC_EXTRACTED_OTHER_PARTS_SORTED
    echo "Output Extracted ACDC Best Price Parts "$ACDC_EXTRACTED_OTHER_SLIC_PRICED_PARTS

    $scm_exe/ACDCOtherPartsM -a$ACDC_EXTRACTED_OTHER_PARTS_SORTED -b$ACDC_EXTRACTED_OTHER_SLIC_PRICED_PARTS -c$FISCAL_PERIOD -d$PROCESSING_MDL
    rc=$?
    if [ $rc -eq 0 ]
    then
      wc -l $ACDC_EXTRACTED_OTHER_SLIC_PRICED_PARTS
      echo "*******************************************************************************"
      echo "***      Sucessful Completion of ACDC Other Part Pricing `date`             ***"
      echo "*******************************************************************************"
    else
      rc=110
      echo "*******************************************************************************"
      echo "***      Abnormal Termination of ACDC Other Part Pricing `date`             ***"
      echo "*******************************************************************************"
    fi
  fi
  return $rc
}

consolidateNoOrderBestPriceAndOther() {
  if [ $rc -eq 0 ]
  then
    echo "#----------------------------------------------------------------------------------------#"
    echo "#------------ Consolidate No Order Best Price Data and Other Parts `date` ---------------#"
    echo "#----------------------------------------------------------------------------------------#"
    ACDC_CONSOLIDATED_ALL_PARTS=$dta_scm/ACDCBestPrice_Consolidate_ALL_Priced_Parts_M.txt
    echo "Input Extracted ACDC No Order Parts "$ACDC_EXTRACTED_NO_ORDER_PARTS
    echo "Input Extracted ACDC Best Price Parts "$ACDC_EXTRACTED_BEST_PRICE_PARTS
    echo "Input Extracted Other ACDC Parts Sorted "$ACDC_EXTRACTED_OTHER_SLIC_PRICED_PARTS
    echo "Output Consolidated All Pricing Record "$ACDC_CONSOLIDATED_ALL_PARTS

    sort -u -o$ACDC_CONSOLIDATED_ALL_PARTS $ACDC_EXTRACTED_BEST_PRICE_PARTS $ACDC_EXTRACTED_NO_ORDER_PARTS $ACDC_EXTRACTED_OTHER_SLIC_PRICED_PARTS
    rc=$?
    if [ $rc -eq 0 ]
    then
      wc -l $ACDC_CONSOLIDATED_ALL_PARTS
      echo "*******************************************************************************"
      echo "***      Sucessful Completion of Consolidate ALL Pricing Records `date`     ***"
      echo "*******************************************************************************"
    else
      rc=120
      echo "*******************************************************************************"
      echo "***      Abnormal Termination of Consolidate ALL Pricing Records `date`     ***"
      echo "*******************************************************************************"
    fi
  fi
  return $rc
}

loadACDCbestPricesTablePass2() {
  if [ $rc -eq 0 ]
  then
    echo "#----------------------------------------------------------------------------------------#"
    echo "#------------ Load ACDC Best Price Table Pass 2 `date`    -------------------------------#"
    echo "#----------------------------------------------------------------------------------------#"
    DATAFILE=$ACDC_CONSOLIDATED_ALL_PARTS;export DATAFILE 
    CTLFILE=$scm_home/load/ACDC_Best_Price_multi.ctl;export CTLFILE
    LOGFILE=$dta_scm/acdc_best_price_pass2_M.log;export LOGFILE
    BADFILE=$dta_scm/acdc_best_price_pass2_M.bad;export BADFILE
    DISCFILE=$dta_scm/acdc_best_price_pass2_M.dsc;export DISCFILE

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
        echo "\r\t*******************************************"
        echo "\r\tSuccessful load of ACDC Best Prices Pass 2 `date`"
        echo "\r\t******************************************"
        rc=0
        cat $LOGFILE
      else
        echo "\r\t????????????????????????????????"
        echo "\r\tUnsuccessful load of ACDC `date` "
        echo "\r\t????????????????????????????????"
        rc=20
        fi
    else
      echo "Unable to locate load file " $DATAFILE
      rc=21
    fi
  fi
  return $rc
}

menu() {
  echo "0. extractPartMfgList"
  echo "1. extractBestPrice"
  echo "2. extractPBOM_NoOrderPart"
  echo "3. consolidateNoOrderAndBestPrice"
  echo "4. loadACDCbestPricesPass1"
  echo "5. getGoldData"
  echo "6. processOtherParts"
  echo "7. consolidateNoOrderBestPriceAndOther"
  echo "8. loadACDCbestPricesTablePass2"
}

main() {
  if [  $stepnum -eq 0 ] ; then
    extractPartMfgList
    rc=$?
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 1 ] ; then
    extractBestPrice 
    rc=$?
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 2 ] ; then
    extractPBOM_NoOrderPart
    rc=$?
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 3 ] ; then
    consolidateNoOrderAndBestPrice
    rc=$?
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 4 ] ; then
    loadACDCbestPricesPass1
    rc=$?
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 5 ] ; then
    getGoldData
    rc=$?
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 6 ] ; then
    processOtherParts
    rc=$?
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 7 ] ; then
    consolidateNoOrderBestPriceAndOther
    rc=$?
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 8 ] ; then
    loadACDCbestPricesTablePass2
    rc=$?
    let stepnum=$stepnum+1
  fi

  echo "---------------------------------------------------------------------------"
  echo "--- ACDC Build Best Price Table completion `date`                     -----"
  echo "--- Return Code " $rc
  echo "---------------------------------------------------------------------------"
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
  echo -e "From: ACDCBestPriceM.sh Script\nSubject: Successful Completion of ACDC Load Best Price Table\nTo: ${RECIPIENTS}" | more $SYSOUT | sed '/^~/s/~//' | sendmail -t
else
  echo -e "From: ACDCBestPriceM.sh Script\nSubject: Unsuccessful Completion of ACDC Load Best Price Table\nTo: ${RECIPIENTS}" | more $SYSOUT | sed '/^~/s/~//' | sendmail -t
fi

chmod 770 $SYSOUT

exit $rc
