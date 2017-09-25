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

setup() {
  echo "----------------------------------------------------------------"
  echo "--- build acdc best price table `date`                     -----"
  echo "---          acdcbestprice.sh                              -----"
  echo "----------------------------------------------------------------"

  ####################################################################################
  #export two_task=stl_prodsup01
  ####################################################################################

  echo "command being executed - "$0
  echo "arguments being passed - "$*
  echo "number of arguments "$#
  echo "PSS_DB  "$PSS_DB
  echo "PSS_ENV  "$PSS_ENV
  echo "HOSTNAME "`hostname`
  PARMFILE=$scm_home/load;export PARMFILE

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

  ####################################################################################
  FISCAL_PERIOD=ta9_order
  PROCESSING_MDL=f18
  ####################################################################################

  rc=0

}

extractPartMfgList() {
  echo "#----------------------------------------------------------------------------------------#"
  echo "#------------ Extract Part/MFG Codes from ACDC Data Table `date` ------------------------#"
  echo "#----------------------------------------------------------------------------------------#"
  SCHEMA=`cat $ORALOGIN/.SCM_destn`
  ACCESS=`cat $ORALOGIN/.SCM_pass`
  CONNECT=$SLICSRV
  ACDC_EXTRACTED_PARTS=$dta_scm/ACDCBestPrice_Extracted_Parts.txt
  echo "Extracted ACDC Parts "$ACDC_EXTRACTED_PARTS
  echo "Extracted ACDC Parts "$ACDC_EXTRACTED_PARTS

  sqlplus -L ${SCHEMA}@${CONNECT}/${ACCESS} @$scm_sql/ACDCBestPrice_get_parts.sql $ACDC_EXTRACTED_PARTS
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
    echo "#----------------------------------------------------------------------------------------#"
    echo "#------------ Extract Best Price from ACDC Data Table `date` ----------------------------#"
    echo "#----------------------------------------------------------------------------------------#"
    ACDC_EXTRACTED_PARTS=$dta_scm/ACDCBestPrice_Extracted_Parts.txt
    ACDC_EXTRACTED_BEST_PRICE_PARTS=$dta_scm/ACDCBestPrice_Parts.txt
    echo "Input Extracted ACDC Parts "$ACDC_EXTRACTED_PARTS
    echo "Output Extracted ACDC Best Price Parts "$ACDC_EXTRACTED_BEST_PRICE_PARTS

    $scm_exe/ACDCBestPrice -a${ACDC_EXTRACTED_PARTS} -b${ACDC_EXTRACTED_BEST_PRICE_PARTS} -c${FISCAL_PERIOD}
    rc=$?
    if [ $rc -eq 0 ]
    then
      wc -l $ACDC_EXTRACTED_BEST_PRICE_PARTS
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

  return $rc

}

extractPBOM_NoOrderPart() {

    echo "#----------------------------------------------------------------------------------------#"
    echo "#------------ Extract PBOM No Order Part `date`           -------------------------------#"
    echo "#----------------------------------------------------------------------------------------#"
    ACDC_EXTRACTED_NO_ORDER_PARTS=$dta_scm/ACDCBestPrice_NoOrder_Parts.txt
    echo "Output Extracted ACDC No Order Parts "$ACDC_EXTRACTED_NO_ORDER_PARTS

    $scm_exe/ACDCNoOrderParts -a$ACDC_EXTRACTED_NO_ORDER_PARTS -b$FISCAL_PERIOD -c$PROCESSING_MDL
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

  return $rc

}

consolidateNoOrderAndBestPrice() {
    echo "#----------------------------------------------------------------------------------------#"
    echo "#------------ Consolidate No Order and Best Price Data `date` ---------------------------#"
    echo "#----------------------------------------------------------------------------------------#"
    ACDC_CONSOLIDATED_BEST_PRICE_PARTS=$dta_scm/ACDCBestPrice_Consolidate_Priced_Parts.txt
    ACDC_EXTRACTED_BEST_PRICE_PARTS=$dta_scm/ACDCBestPrice_Parts.txt
    ACDC_EXTRACTED_NO_ORDER_PARTS=$dta_scm/ACDCBestPrice_NoOrder_Parts.txt
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

  return $rc

}

loadACDCbestPricesPass1() {
    echo "#----------------------------------------------------------------------------------------#"
    echo "#------------ Load ACDC Best Price Table Pass 1 `date`    -------------------------------#"
    echo "#----------------------------------------------------------------------------------------#"
    ACDC_CONSOLIDATED_BEST_PRICE_PARTS=$dta_scm/ACDCBestPrice_Consolidate_Priced_Parts.txt
    SCHEMA=`cat $ORALOGIN/.SCM_destn`
    ACCESS=`cat $ORALOGIN/.SCM_pass`
    CONNECT=$SLICSRV
    DATAFILE=$ACDC_CONSOLIDATED_BEST_PRICE_PARTS;export DATAFILE 
    CTLFILE=$scm_home/load/ACDC_Best_Price.ctl;export CTLFILE
    LOGFILE=$dta_scm/acdc_best_price.log;export LOGFILE
    BADFILE=$dta_scm/acdc_best_price.bad;export BADFILE
    DISCFILE=$dta_scm/acdc_best_price.dsc;export DISCFILE

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

  return $rc

}

getGoldData() {
    echo "#----------------------------------------------------------------------------------------#"
    echo "#------------ Extract Other Part/MFG Codes from Gold Data Table  `date` -----------------#"
    echo "#----------------------------------------------------------------------------------------#"
    SCHEMA=`cat $ORALOGIN/.SCM_LB_destn`
    ACCESS=`cat $ORALOGIN/.SCM_LB_pass`
    CONNECT=$SLICSRV
    ACDC_EXTRACTED_OTHER_PARTS=$dta_scm/ACDCBestPrice_Extracted_Other_Parts.txt
    ACDC_EXTRACTED_OTHER_PARTS_SORTED=$dta_scm/ACDC_Extracted_Other_Parts_Sorted.txt
    echo "Extracted Other ACDC Parts "$ACDC_EXTRACTED_OTHER_PARTS
    echo "Extracted Other ACDC Parts "$ACDC_EXTRACTED_OTHER_PARTS

    sqlplus -L ${SCHEMA}@${CONNECT}/${ACCESS} @$scm_sql/ACDCOtherParts.sql $ACDC_EXTRACTED_OTHER_PARTS
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
      ACDC_EXTRACTED_OTHER_PARTS_SORTED=$dta_scm/ACDCBestPrice_Extracted_Other_Parts_Sorted.txt
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

  return $rc

}

processOtherParts() {
    echo "#----------------------------------------------------------------------------------------#"
    echo "#------------ Process ACDC Other Parts `date`             -------------------------------#"
    echo "#----------------------------------------------------------------------------------------#"
    ACDC_EXTRACTED_OTHER_SLIC_PRICED_PARTS=$dta_scm/ACDCBestPrice_Extracted_Other_Parts_SLIC.txt
    ACDC_EXTRACTED_OTHER_PARTS_SORTED=$dta_scm/ACDCBestPrice_Extracted_Other_Parts_Sorted.txt
    echo "Input Extracted ACDC Parts "$ACDC_EXTRACTED_OTHER_PARTS_SORTED
    echo "Output Extracted ACDC Best Price Parts "$ACDC_EXTRACTED_OTHER_SLIC_PRICED_PARTS
    echo "FISCAL_PERIOD=" $FISCAL_PERIOD
    echo "PROCESSING_MDL=" $PROCESSING_MDL

    $scm_exe/ACDCOtherParts -a$ACDC_EXTRACTED_OTHER_PARTS_SORTED -b$ACDC_EXTRACTED_OTHER_SLIC_PRICED_PARTS -c$FISCAL_PERIOD -d$PROCESSING_MDL
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

  return $rc

}

consolidateNoOrderBestPriceAndOther() {
    echo "#----------------------------------------------------------------------------------------#"
    echo "#------------ Consolidate No Order Best Price Data and Other Parts `date` ---------------#"
    echo "#----------------------------------------------------------------------------------------#"
    ACDC_CONSOLIDATED_ALL_PARTS=$dta_scm/ACDCBestPrice_Consolidate_ALL_Priced_Parts.txt
    ACDC_EXTRACTED_OTHER_PARTS_SORTED=$dta_scm/ACDCBestPrice_Extracted_Other_Parts_Sorted.txt
    ACDC_EXTRACTED_NO_ORDER_PARTS=$dta_scm/ACDCBestPrice_NoOrder_Parts.txt
    ACDC_EXTRACTED_OTHER_SLIC_PRICED_PARTS=$dta_scm/ACDCBestPrice_Extracted_Other_Parts_SLIC.txt
    ACDC_EXTRACTED_BEST_PRICE_PARTS=$dta_scm/ACDCBestPrice_Parts.txt
    echo "Input Extracted ACDC No Order Parts "$ACDC_EXTRACTED_NO_ORDER_PARTS
    echo "Input Extracted ACDC Best Price Parts "$ACDC_EXTRACTED_BEST_PRICE_PARTS
    echo "Input Extracted Other ACDC Parts Sorted "$ACDC_EXTRACTED_OTHER_PARTS_SORTED
    echo "Output Consolidated All Pricing Record "$ACDC_CONSOLIDATED_ALL_PARTS

    sort -o$ACDC_CONSOLIDATED_ALL_PARTS $ACDC_EXTRACTED_BEST_PRICE_PARTS $ACDC_EXTRACTED_NO_ORDER_PARTS $ACDC_EXTRACTED_OTHER_SLIC_PRICED_PARTS
    rc=$?
    if [ $rc -eq 0 ]
    then
      ACDC_CONSOLIDATED_NO_DUP_PARTNO=$dta_scm/ACDCBestPrice_Consolidate_No_Dup_PartNo.txt
      # eliminate rec's with dup part numbers
      awk '{a[$1]++}!(a[$1]-1)' $ACDC_CONSOLIDATED_ALL_PARTS > $ACDC_CONSOLIDATED_NO_DUP_PARTNO
      rc=$?
      if [ $rc -eq 0 ] ; then
        wc -l $ACDC_CONSOLIDATED_NO_DUP_PARTNO
        echo "*******************************************************************************"
        echo "***      Sucessful Completion of Consolidate ALL Pricing Records `date`     ***"
        echo "*******************************************************************************"
      else
        echo "*******************************************************************************"
        echo "***      Abnormal Completion of Duplicate Part Filter `date`     ***"
        echo "*******************************************************************************"
      fi
    else
      rc=120
      echo "*******************************************************************************"
      echo "***      Abnormal Termination of Consolidate ALL Pricing Records `date`     ***"
      echo "*******************************************************************************"
    fi

  return $rc

}

loadACDCbestPricesTablePass2() {
    echo "#----------------------------------------------------------------------------------------#"
    echo "#------------ Load ACDC Best Price Table Pass 2 `date`    -------------------------------#"
    echo "#----------------------------------------------------------------------------------------#"
    ACDC_CONSOLIDATED_NO_DUP_PARTNO=$dta_scm/ACDCBestPrice_Consolidate_No_Dup_PartNo.txt
    SCHEMA=`cat $ORALOGIN/.SCM_destn`
    ACCESS=`cat $ORALOGIN/.SCM_pass`
    CONNECT=$SLICSRV
    DATAFILE=$ACDC_CONSOLIDATED_NO_DUP_PARTNO;export DATAFILE 
    CTLFILE=$scm_home/load/ACDC_Best_Price.ctl;export CTLFILE
    LOGFILE=$dta_scm/acdc_best_price_pass2.log;export LOGFILE
    BADFILE=$dta_scm/acdc_best_price_pass2.bad;export BADFILE
    DISCFILE=$dta_scm/acdc_best_price_pass2.dsc;export DISCFILE

    echo "Data File " $DATAFILE
    echo "Control File " $CTLFILE
    echo "Log File " $LOGFILE
    echo "Bad File " $BADFILE
    echo "Discard File " $DISCFILE
    echo "Oracle Data Base Version "$PSS_VRSN
    echo "Oracle SID "$PSS_ORACLE_SID
    echo "Data Base Machine "$PSS_DB

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

current_time=$(date "+%Y_%m_%d_%H_%M_%S")
SYSOUT=/tmp/${current_time}_ACDCBestPrice_out.txt
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
  echo -e "From: ACDCBestPrice.sh Script\nSubject: Successful Completion of ACDC Load Best Price Table\nTo: ${RECIPIENTS}" | more $SYSOUT | sed '/^~/s/~//' | sendmail -t
else
  echo -e "From: ACDCBestPrice.sh Script\nSubject: Unsuccessful Completion of ACDC Load Best Price Table\nTo: ${RECIPIENTS}" | more $SYSOUT | sed '/^~/s/~//' | sendmail -t
fi

chmod 770 $SYSOUT

exit $rc
