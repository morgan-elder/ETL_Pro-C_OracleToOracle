#!/bin/sh
# vim: ts=2:sw=2 sts=2:expandtab:
# Author: Larry Mills
# Date: 2/2/2015
# Rev: 1.6
# Rev 1.6 2/2/2015 by Douglas Elder add /usr/sbin to path so sendmail can be found
# Rev 1.5 1/21/2015 by Douglas Elder use sendmail instead of mailx to get
#                                    message content into the body of the email
# Rev 1.4 1/12/2015 by Douglas Elder make sure sysout can be removed by group,
#                                    fix step error message
#                                    add -o command line opt for sysout file
# Rev: 1.3 forced delete for sysout
# Rev: 1.2 removed old sysout file references
# Rev 1.1 by Douglas Elder broke out individual steps added getopts
#

DBGECHO=
DEBUG=
APIDBG=
STEP=
stepnum=0
rc=0
# return any non-zero return code
# when any piped command fails
set -o pipefail

usage() {
 echo >&2 "Usage: $0 [ -a -d -e -f -m -s step -x ]"
 echo >&2 "  -a sortAltPrimes step"
 echo >&2 "  -d turn on debug"
 echo >&2 "  -e echo the command lines"
 echo >&2 "  -f fmt step"
 echo >&2 "  -m show step menu"
 echo >&2 "  -n stepname where stepname is one of the steps in this script"
 echo >&2 "  -o SYSOUT filename"
 echo >&2 "  -s stepnum where stepnum is 0 to 23"
 echo >&2 "  -x debug gldCATAPIU - i.e. don't create any GOLD transactions"
}

while getopts adefmn:o:rs:x o
do  case "$o" in
  a)  STEP=sortAltPrimes ;;
  d)  DEBUG=Y 
      set -x ;;
  e)  DBGECHO=echo  ;;
  f)  STEP=fmt ;;
  r)  STEP=reorderMergedApiFile ;;
  m)  STEP=menu ;;
  n)  STEP=$OPTARG ;;
  o)  SYSOUT=$OPTARG ;;
  s)  stepnum=$OPTARG ;;
  x)  APIDBG=-x ;;
  ?)  usage
      exit 1;;
  esac
done
shift $(( $OPTIND - 1))

if (($#>0)) ; then
  RECIPIENTS=$1
else
  if [ `logname` = "zf297a" -o `logname` = "slic2gld" ] ; then
    RECIPIENTS=douglas.s.elder@boeing.com
  else
    RECIPIENTS=joseph.t.conley@boeing.com
  fi
fi


setup() {
  echo -e "\n"
  . /mcair/rel/appl/pss_shared/public/set_pss_env_no_login
  rc=$?
  ORALOGIN=/data/scm/sh/oralogin
  export ORALOGIN
  

  # set work dir using TMPDIR env var for extra sort space 9/5/2012 dse
  if [ -d  /scratch ] ; then
    TMPDIR=/scratch
    export TMPDIR
  else
    TMPDIR=/tmp
    export TMPDIR
  fi

  echo -e "\n#*******************************************************************#" 
  echo "* Start of SLIC/GOLD Extract - " `date` 
  echo "* Processing Environment - " $PSS_ENV 
  echo "#*******************************************************************#" 

  PROCESSING_MODEL="F15";export PROCESSING_MODEL
  if [ $rc -ne 0 ]
  then
    echo -e "\n##############################################################" 
    echo -e "\nExit Code from set_common_env " $rc 
    echo -e "\nProcessing of $PROCESSING_MODEL SLIC/Gold Extract Program was not Successfully Completed - `date`" 
    echo -e "\n##############################################################" 
    errcode=500
    echo "SLIC/Gold Interface Exit Code " $errcode 
    exit $errcode
  fi

  #. /mcair/dev/appl/scm/public/setup_scm_sh
  . /data/scm/public/setup_scm_sh

  scm_public=/data/scm/public;export scm_public
  scm_exe=/data/scm/c/exe;export scm_exe
  #
  echo "SCM_EXE "$scm_exe

  PATH=/usr/sbin:$PATH:$scm_public:
  export PATH
  echo $scm_public

  . $scm_public/setup_scm_sh

  echo $GOLDSRV
  echo $SLICSRV

  PROCESSING_MODEL="F15";export PROCESSING_MODEL

  DOMAINNAME=`domainname`

  echo $DOMAINNAME 
  echo $PSS_ENV 

  #
  #  Setup output Datasets
  #

  if [ $PSS_ENV = "PRODN" ]
  then
          DATA_DIR=/data/scm/PROD;export DATA_DIR
  else
          DATA_DIR=/data/scm/TEST;export DATA_DIR
  fi
}


hax04() {
  echo -e "\n#*******************************************************************#" 
  echo "#     Extract HAX04 Change Activity - " `date`
  echo "#*******************************************************************#" 
  echo "#" 
  SLICGLD_HAX04=$DATA_DIR/$PROCESSING_MODEL"_api_slicgld_hax04.dta";export SLICGLD_HAX04

  $DBGECHO $scm_exe/slicgldHAX04 -a$SLICGLD_HAX04 -b$PROCESSING_MODEL
  rc=$?
  echo "Return Code = " $rc 
  if [ $rc -eq 0 ]
  then
    echo -e "\n*************************************************************" 
    echo "* Successful completion of SLIC/Gold HAX04 Change Activity Extract Program - `date`" 
    echo "*************************************************************" 
    errcode=0
  else

    echo -e "\n##############################################################" 
    echo "# Unsuccessful completion of SLIC/Gold HAX04 Change Activity Extract Program - `date`" 
    echo $scm_exe/slicgldHAX04 -a$SLICGLD_HAX04 -b$PROCESSING_MODEL
    echo "##############################################################" 
    errcode=10
  fi
  chmod 660 $SLICGLD_HAX04
  return $errcode
} 

ha() {
  echo -e "\n#*******************************************************************#" 
  echo "#     Extract HA Change Activity - "`date` 
  echo "#*******************************************************************#" 
  echo "#" 
  SLICGLD_HA=$DATA_DIR/$PROCESSING_MODEL"_api_slicgld_ha.dta";export SLICGLD_HA
  $DBGECHO  $scm_exe/slicgldHA -a$SLICGLD_HA -b$PROCESSING_MODEL
  rc=$?


  echo "Return Code = " $rc 
  echo "Return Code = " $rc 
  if [ $rc -eq 0 ]
  then
    echo -e "\n*************************************************************" 
    echo "* Successful completion of SLIC/Gold HA Change Activity Extract Program - `date`" 
    echo "*************************************************************" 
    errcode=0
  else
    echo -e "\n##############################################################" 
    echo "# Unsuccessful completion of SLIC/Gold HA Change Activity Extract Program - `date`" 
    echo $scm_exe/slicgldHA -a$SLICGLD_HA -b$PROCESSING_MODEL
    echo "##############################################################" 
    errcode=20
  fi
  chmod 660 $SLICGLD_HA
  return $errcode
}

hb() {
  SLICGLD_HB=$DATA_DIR/$PROCESSING_MODEL"_api_slicgld_hb.dta";export SLICGLD_HB
  SLICGLD_HB_REPORT=$DATA_DIR/$PROCESSING_MODEL"_api_slicgld_hb_report.dta";export SLICGLD_HB_REPORT
  echo -e "\n#*******************************************************************#" 
  echo "#     Extract HB Change Activity - "`date`
  echo "# SLIC HB Change File "$SLICGLD_HB 
  echo "# SLIC HB Error Report "$SLICGLD_HB_REPORT
  echo "#*******************************************************************#" 
  echo "#" 
  $DBGECHO $scm_exe/slicgldHB -a$SLICGLD_HB -b$SLICGLD_HB_REPORT -d$PROCESSING_MODEL
  rc=$?


  echo "Return Code = " $rc 
  if [ $rc -eq 0 ]
  then
    echo -e "\n*************************************************************" 
    echo "* Successful completion of SLIC/Gold HB Change Activity Extract Program - `date`" 
    echo "*************************************************************" 
    errcode=0
  else
    echo -e "\n##############################################################" 
    echo "# Unsuccessful completion of SLIC/Gold HB Change Activity Extract Program - `date`" 
    echo $scm_exe/slicgldHB -a$SLICGLD_HB -b$SLICGLD_HB_REPORT -d$PROCESSING_MODEL
    echo "##############################################################" 
    errcode=30
  fi
  chmod 660 $SLICGLD_HB $SLICGLD_HB_REPORT
  return $errcode
}

hp() {
  SLICGLD_HP=$DATA_DIR/$PROCESSING_MODEL"_api_slicgld_hp.dta";export SLICGLD_HP
  SLICGLD_HP_RPT=$DATA_DIR/$PROCESSING_MODEL"_api_slicgld_hp_rpt.dta";export SLICGLD_HP_RPT
  echo -e "\n#*******************************************************************#" 
  echo "#     Extract HP Change Activity - "`date` 
  echo "#Output HP Activity "$SLICGLD_HP
  echo "#Output HP Mail File "$SLICGLD_HP_RPT
  echo "#*******************************************************************#" 
  echo "#" 
  $DBGECHO $scm_exe/slicgldHP -a$SLICGLD_HP -b$SLICGLD_HP_RPT -c$PROCESSING_MODEL
  rc=$?


  echo "Return Code = " $rc 
  if [ $rc -eq 0 ]
  then
    nbr_of_rcds=`wc -l $SLICGLD_HP_RPT|awk '{ print $1 }'`
    if [ $nbr_of_rcds -gt 0 ] ; then
      more $scm_sh/api_hp_msg_template > $DATA_DIR/${PROCESSING_MODEL}_api_hp_mail_msg;
      more $SLICGLD_HP_RPT|sort -u >> $DATA_DIR/${PROCESSING_MODEL}_api_hp_mail_msg;
      more $DATA_DIR/$PROCESSING_MODEL"_api_hp_mail_msg"
    else
      echo "No Supersedure Information to Report" 
    fi
    if [ -e $DATA_DIR/${PROCESSING_MODEL}_api_hp_mail_msg ] ; then
      chmod 660 $DATA_DIR/${PROCESSING_MODEL}_api_hp_mail_msg;
    fi
    echo -e "\n*************************************************************" 
    echo "* Successful completion of SLIC/Gold HP Change Activity Extract Program - `date`" 
    echo "*************************************************************" 
    errcode=0
  else
    echo -e "\n##############################################################" 
    echo "# Unsuccessful completion of SLIC/Gold HP Change Activity Extract Program - `date`" 
    echo $scm_exe/slicgldHP -a$SLICGLD_HP -b$SLICGLD_HP_RPT -c$PROCESSING_MODEL
    echo "##############################################################" 
    errcode=40
  fi
  chmod $SLICGLD_HP $SLICGLD_HP_RPT 
  return $errcode

}

hg() {
  echo -e "\n#*******************************************************************#" 
  echo "#     Extract HG Change Activity - "`date` 
  echo "#*******************************************************************#" 
  echo "#" 
  SLICGLD_HG=$DATA_DIR/$PROCESSING_MODEL"_api_slicgld_hg.dta";export SLICGLD_HG
  $DBGECHO $scm_exe/slicgldHG -a$SLICGLD_HG -b$PROCESSING_MODEL
  rc=$?


  echo "Return Code = " $rc 
  if [ $? -eq 0 ]
  then
    echo -e "\n*************************************************************" 
    echo "* Successful completion of SLIC/Gold HG Change Activity Extract Program - `date`" 
    echo "*************************************************************" 
    errcode=0
  else
    echo -e "\n##############################################################" 
    echo "# Unsuccessful completion of SLIC/Gold HG Change Activity Extract Program - `date`" 
    echo $scm_exe/slicgldHG -a$SLICGLD_HG -b$PROCESSING_MODEL
    echo "##############################################################" 
    errcode=45
  fi
  chmod 660 $SLICGLD_HG
  return $errcode

}

sortConsolidated()  {
  SLICGLD_HB=$DATA_DIR/$PROCESSING_MODEL"_api_slicgld_hb.dta";export SLICGLD_HB
	SLICGLD_HP=$DATA_DIR/$PROCESSING_MODEL"_api_slicgld_hp.dta";export SLICGLD_HP
	SLICGLD_HG=$DATA_DIR/$PROCESSING_MODEL"_api_slicgld_hg.dta";export SLICGLD_HG
	SLICGLD_HA=$DATA_DIR/$PROCESSING_MODEL"_api_slicgld_ha.dta";export SLICGLD_HA
	SLICGLD_HAX04=$DATA_DIR/$PROCESSING_MODEL"_api_slicgld_hax04.dta";export SLICGLD_HAX04  
  echo -e "\n#*******************************************************************#" 
  echo "#     Sort Consolidated Change Activity - "`date` 
  echo "#*******************************************************************#" 
  echo "#" 
  API_CNSLDTD_SLICGLD_SRTD_CHG_ACTY=$DATA_DIR/$PROCESSING_MODEL"_api_slicgld_srtd_chg.dta";export API_CNSLDTD_SLICGLD_SRTD_CHG_ACTY
  echo -e "\n#*******************************************************************#" 
  echo -e "#Sortin HB Activity\t"$SLICGLD_HB 
  echo -e "#Sortin HP Activity\t"$SLICGLD_HP 
  echo -e "#Sortin HG Activity\t"$SLICGLD_HG 
  echo -e "#Sortin HA Activity\t"$SLICGLD_HA 
  echo -e "#Sortin HAX04 Activity\t"$SLICGLD_HAX04 
  echo -e "#Sortout Activity\t"$API_CNSLDTD_SLICGLD_SRTD_CHG_ACTY
  echo "#*******************************************************************#" 
  $DBGECHO  sort -u -o$API_CNSLDTD_SLICGLD_SRTD_CHG_ACTY $SLICGLD_HB $SLICGLD_HP $SLICGLD_HG $SLICGLD_HA $SLICGLD_HAX04
  rc=$?


  echo "Return Code = " $rc 
  if [ $rc -eq 0 ]
  then
    echo -e "\n*************************************************************" 
    echo "* Successful completion of Change Activity Sort - `date`" 
    echo "-e *\t"|wc -l $API_CNSLDTD_SLICGLD_SRTD_CHG_ACTY
    echo "*************************************************************" 
    errcode=0
  else
    echo -e "\n##############################################################" 
    echo "# Unsuccessful Completed of Change Activity Sort - `date`" 
    echo sort -u -o$API_CNSLDTD_SLICGLD_SRTD_CHG_ACTY $SLICGLD_HB $SLICGLD_HP $SLICGLD_HG $SLICGLD_HA $SLICGLD_HAX04
    echo "##############################################################" 
    errcode=50
  fi
  chmod 660 $API_CNSLDTD_SLICGLD_SRTD_CHG_ACTY
  return $errcode
}

fmt() {
  echo -e "\n#*******************************************************************#"
  echo "* Start of SLIC/GOLD Extract - " `date`
  echo "* Processing Environment - " $PSS_ENV
  echo "#*******************************************************************#"
  echo $DATA_DIR
  API_CNSLDTD_SLICGLD_SRTD_CHG_ACTY=$DATA_DIR/$PROCESSING_MODEL"_api_slicgld_srtd_chg.dta";export API_CNSLDTD_SLICGLD_SRTD_ACTY_FILE
  API_UNSORTED_CAT1_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_unsorted_cat1_output.dta";export API_UNSORTED_CAT1_FILE
  API_UNSORTED_CATS_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_unsorted_cats_output.dta";export API_UNSORTED_CATS_FILE
  API_UNSORTED_WHSE_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_unsorted_whse_output.dta";export API_UNSORTED_WHSE_FILE
  API_UNSORTED_PRC1_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_unsorted_prc1_output.dta";export API_UNSORTED_PRC1_FILE
  API_UNSORTED_VENC_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_unsorted_venc_output.dta";export API_UNSORTED_VENC_FILE
  API_EXCEPTION_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_exception_file.dta";export API_EXCEPTION_FILE
  SHELF_LIFE_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_shelf_life_output.dta";export SHELF_LIFE_FILE

  echo -e "\n#*******************************************************************#"
  echo "#     Create SLIC/GOLD API Rcds                                       #"
  echo "# Input Candidate File "$API_CNSLDTD_SLICGLD_SRTD_CHG_ACTY
  echo "# Output Unsorted CAT1 File (Option B) "$API_UNSORTED_CAT1_FILE
  echo "# Output WHSE File (Option F) "$API_UNSORTED_WHSE_FILE
  echo "# Output VENC File (Option D) "$API_UNSORTED_VENC_FILE
  echo "# Output Exception File (Option H) "$API_EXCEPTION_FILE
  echo "# Output PRC1 File (Option J) "$API_UNSORTED_PRC1_FILE
  echo "# Output CATS File (Option K) "$API_UNSORTED_CATS_FILE
  echo "# Output Shelf Life File (Option L) "$SHELF_LIFE_FILE
  echo "# Processing Model (Option G) "$PROCESS_MODEL
  echo "# Create API File (Option Z) Y "
  echo "#*******************************************************************#"
  echo "#"
  #
  # Option A - Input File
  # Option B - Output CAT1 File
  # Option C - 
  # Option D - Output VENC File
  # Option E - Output Vendor Site File
  # Option F - Output WHSE File
  # Option J - Output PRC1 File
  # Option K - Output CATS File
  # Option L - Output Shelf Life File
  #
  $DBGECHO  $scm_exe/slicgldFMT -a$API_CNSLDTD_SLICGLD_SRTD_CHG_ACTY \
    -b$API_UNSORTED_CAT1_FILE -cN -d$API_UNSORTED_VENC_FILE \
    -f$API_UNSORTED_WHSE_FILE -g$PROCESSING_MODEL -h$API_EXCEPTION_FILE \
    -j$API_UNSORTED_PRC1_FILE -k$API_UNSORTED_CATS_FILE -l$SHELF_LIFE_FILE -zY
  rc=$?


  echo "Return Code = " $rc
  if [ $rc -eq 0 ]
  then
    echo -e "\n*************************************************************"
    echo "* Successful completion of SLIC/Gold API Rcds Create - `date`"
    echo "*************************************************************"
    errcode=0
  else
    echo -e "\n##############################################################"
    echo "# Unsuccessful completion of SLIC/Gold API Rcds Create - `date`"
    echo  $scm_exe/slicgldFMT -a$API_CNSLDTD_SLICGLD_SRTD_CHG_ACTY \
      -b$API_UNSORTED_CAT1_FILE -cN -d$API_UNSORTED_VENC_FILE \
      -f$API_UNSORTED_WHSE_FILE -g$PROCESSING_MODEL -h$API_EXCEPTION_FILE \
      -j$API_UNSORTED_PRC1_FILE -k$API_UNSORTED_CATS_FILE -l$SHELF_LIFE_FILE -zY
    echo "# Return Code "$rc
    echo "##############################################################"
    errcode=60
    echo "Errcode - "$errcode
  fi
  chmod 660 $API_UNSORTED_CAT1_FILE $API_UNSORTED_VENC_FILE \
    $API_UNSORTED_WHSE_FILE  $API_EXCEPTION_FILE \
    $API_UNSORTED_PRC1_FILE $API_UNSORTED_CATS_FILE $SHELF_LIFE_FILE
  return $errcode
}

sortDup() {
  API_SORTED_CAT1_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_sorted_cat1.dta";export API_SORTED_CAT1_RCDS
	API_UNSORTED_CAT1_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_unsorted_cat1_output.dta";export API_UNSORTED_CAT1_FILE  
  echo -e "\n#*******************************************************************#"
  echo "#             Sort Duplicate CAT1 Records"
  echo "# Output Unsorted CAT1 File "$API_UNSORTED_CAT1_FILE
  echo "# Sortout CAT1 File "$API_SORTED_CAT1_FILE
  echo "#*******************************************************************#"
  $DBGECHO sort -u -o$API_SORTED_CAT1_FILE $API_UNSORTED_CAT1_FILE
  rc=$?


  echo "Return Code = " $rc
  if [ $rc -eq 0 ]
  then
    echo -e "\n*************************************************************"
    echo "* Successful completion of CAT1 File Sort - `date`"
    echo "*************************************************************"
    errcode=0
  else
    echo -e "\n##############################################################"
    echo "# Unsuccessful Completed of CAT1 File Sort - `date`"
    echo sort -u -o$API_SORTED_CAT1_FILE $API_UNSORTED_CAT1_FILE
    echo "# Return Code "$rc
    echo "##############################################################"
    errcode=65
    echo "Errcode - "$errcode
  fi  
  chmod 660u $API_SORTED_CAT1_FILE
  return $errcode
}

removeDup() {
  API_PURGED_CAT1_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_purged_cat1.dta";export API_PURGED_CAT1_RCDS
  API_PURGED_CAT1_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_purged_cat1.dta";export API_PURGED_CAT1_RCDS
	API_REJECTD_CAT1_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_rejectd_cat1.dta";export API_REJECTD_CAT1_RCDS
  echo -e "\n#*******************************************************************#"
  echo "#             Remove Duplicate CAT1 Parts"
  echo "# Sortout CAT1 File "$API_SORTED_CAT1_FILE
  echo "# Purged CAT1 File "$API_PURGED_CAT1_FILE
  echo "# Rejected CAT1 File "$API_REJECTD_CAT1_FILE
  echo "#*******************************************************************#"
  $DBGECHO $scm_exe/slicgldCAT1 -a$API_SORTED_CAT1_FILE -b$API_PURGED_CAT1_FILE -c$API_REJECTD_CAT1_FILE
  rc=$?


  echo "Return Code = " $rc
  if [ $rc -eq 0 ]
  then
    echo -e "\n*************************************************************"
    echo "* Successful completion of Removal of Duplicate CAT1 Parts - `date`"
    echo "*************************************************************"
    errcode=0
  else
    echo -e "\n##############################################################"
    echo "* Unsuccessful completion of Removal of Duplicate CAT1 Parts - `date`"
    echo $scm_exe/slicgldCAT1 -a$API_SORTED_CAT1_FILE -b$API_PURGED_CAT1_FILE -c$API_REJECTD_CAT1_FILE
    echo "# Return Code "$rc
    echo "##############################################################"
    errcode=66
    echo "Errcode - "$errcode
  fi
  chmod 660 $API_PURGED_CAT1_FILE $API_REJECTD_CAT1_FILE
  return $errcode
}

sortPrimesAndAlt() {
  export API_PURGED_CAT1_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_purged_cat1.dta"
  export API_PURGED_CAT1_PRIMES_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_purged_cat1_primes.dta"
	export API_PURGED_CAT1_ALTERNATES_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_purged_cat1_alts.dta"
	export API_SORTED_CAT1_PRIMES_ALTERNATES_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_sorted_cat1_primes_alts.dta"
  echo -e "\n#**********************************************************************************#"
  echo "#             Sort Primes and Alternates"
  echo "# Input CAT1 File "$API_PURGED_CAT1_FILE
  echo "# Sorted CAT1 Primes and Alternates File "$API_SORTED_CAT1_PRIMES_ALTERNATES_FILE
  echo "#**********************************************************************************#"
  $DBGECHO  $scm_exe/sortAltPrimes $API_PURGED_CAT1_FILE $API_PURGED_CAT1_PRIMES_FILE $API_PURGED_CAT1_ALTERNATES_FILE
  rc=$?


  echo "Return Code = "$rc
  if [ $rc -eq 0 ]
  then
    echo -e "\n*************************************************************"
    echo "* Successful completion of Prime and Alternate Sort - `date`"
    echo "*************************************************************"
    cat $API_PURGED_CAT1_ALTERNATES_FILE >> $API_PURGED_CAT1_PRIMES_FILE
    cat $API_PURGED_CAT1_PRIMES_FILE > $API_SORTED_CAT1_PRIMES_ALTERNATES_FILE
    rm -f $API_PURGED_CAT1_ALTERNATES_FILE $API_PURGED_CAT1_PRIMES_FILE
    errcode=0
  else
    echo -e "\n##############################################################"
    echo "* Unsuccessful completion of Prime and Alternate Sort - `date`"
    echo $scm_exe/sortAltPrimes $API_PURGED_CAT1_FILE $API_PURGED_CAT1_PRIMES_FILE $API_PURGED_CAT1_ALTERNATES_FILE
    echo "# Return Code "$rc
    echo "##############################################################"
    errcode=68
    echo "Errcode - "$errcode
  fi
  chmod 660 $API_PURGED_CAT1_PRIMES_FILE $API_PURGED_CAT1_ALTERNATES_FILE
  return $errcode
}

assignImsDes() {
  API_ASSIGND_IMS_DES_CDS=$DATA_DIR/$PROCESSING_MODEL"_api_assignd_ims_des_cds.dta";export API_ASSIGND_IMS_DES_CDS
	API_ASSIGND_IMS_DES_CDS_ERRS=$DATA_DIR/$PROCESSING_MODEL"_api_assignd_ims_des_cds_errs.dta";export API_ASSIGND_IMS_DES_CDS_ERRS
	API_ASSIGND_IMS_DES_CDS_DEFLTS=$DATA_DIR/$PROCESSING_MODEL"_api_assignd_ims_des_cds_deflts.txt";export API_ASSIGND_IMS_DES_CDS_DEFLTS
	API_ASSIGND_IMS_DES_CDS_MAIL_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_assignd_ims_des_mail_file.dta";export API_ASSIGND_IMS_DES_CDS_MAIL_FILE
 	export API_SORTED_CAT1_PRIMES_ALTERNATES_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_sorted_cat1_primes_alts.dta"
# echo -e "\n#*******************************************************************#"
# echo "#             Assign IMS Designator Processing"
# echo "# Input CAT1 File "$API_SORTED_CAT1_PRIMES_ALTERNATES_FILE
  echo "# Assigned IMS Des Cde CAT1 File "$API_ASSIGND_IMS_DES_CDS
# echo "# IMS Des Code Error File File "$API_ASSIGND_IMS_DES_CDS_ERRS
# echo "# Assigned IMS Des Cde Default Mail File "$API_ASSIGND_IMS_DES_CDS_DEFLTS
# echo "#*******************************************************************#"
# export TWO_TASK=$SLICSRV
#-----------------------------------------------------------------------------------------------------------------
#----------------     assignIMSDesC Program not being run for F15 ------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------
  $DBGECHO sort -o $API_ASSIGND_IMS_DES_CDS $API_SORTED_CAT1_PRIMES_ALTERNATES_FILE
  rc=$?


  wc -l $API_SORTED_CAT1_PRIMES_ALTERNATES_FILE
  wc -l $API_ASSIGND_IMS_DES_CDS
   $API_ASSIGND_IMS_DES_CDS $API_SORTED_CAT1_PRIMES_ALTERNATES_FILE
  return $rc
}

createACTD() {
  API_ASSIGND_IMS_DES_CDS=$DATA_DIR/$PROCESSING_MODEL"_api_assignd_ims_des_cds.dta";export API_ASSIGND_IMS_DES_CDS
  API_UNSORTED_ACTD_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_unsorted_actd_output.dta";export API_UNSORTED_ACTD_FILE
	API_ACTD_EXCEPTION_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_actd_errors.dta";export API_ACTD_EXCEPTION_FILE
	API_ACTD_DELETION_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_actd_delete_file.dta";export API_ACTD_DELETION_FILE
	API_CAT1_ACTD_UPDATE_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_cat1_actd_output.dta";export API_CAT1_ACTD_UPDATE_FILE
	SHELF_LIFE_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_shelf_life_output.dta";export SHELF_LIFE_FILE
  
  echo -e "\n#*******************************************************************#"
  echo "#             Create ACTD File"
  echo "# Input Shelf Life File "$SHELF_LIFE_FILE
  echo "# Output ACTD API File "$API_UNSORTED_ACTD_FILE
  echo "# ACTD Errors File "$API_ACTD_EXCEPTION_FILE
  echo "# ACTD Delete File "$API_ACTD_DELETION_FILE
  echo "#*******************************************************************#"
  
  $DBGECHO $scm_exe/slicgldACTD $SHELF_LIFE_FILE $API_UNSORTED_ACTD_FILE \
    $API_ACTD_EXCEPTION_FILE $API_ACTD_DELETION_FILE \
    $API_ASSIGND_IMS_DES_CDS $API_CAT1_ACTD_UPDATE_FILE
  rc=$?
  

  if [ rc -eq 0 ]
    then
    echo -e "\n*************************************************************"
    echo "* Successful completion of Create ACTD File - `date`"
    echo "*************************************************************"
    errcode=0
  else
  
    echo -e "\n##############################################################"
    echo "# Unsuccessful Completion of Create ACTD File - `date`"
    echo $scm_exe/slicgldACTD $SHELF_LIFE_FILE $API_UNSORTED_ACTD_FILE \
      $API_ACTD_EXCEPTION_FILE $API_ACTD_DELETION_FILE \
      $API_ASSIGND_IMS_DES_CDS $API_CAT1_ACTD_UPDATE_FILE
    echo "# Return Code "$rc
    echo "##############################################################"
    errcode=75
    echo "Errcode - "$errcode
  fi
  chmod 660 $API_UNSORTED_ACTD_FILE \
    $API_ACTD_EXCEPTION_FILE $API_ACTD_DELETION_FILE \
    $API_ASSIGND_IMS_DES_CDS $API_CAT1_ACTD_UPDATE_FILE
  return $errcode
}

mergeCat1() {
   API_MERGED_CAT1_ACTD_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_merged_cat1_actd_output.dta";export API_MERGED_CAT1_ACTD_FILE
    API_ASSIGND_IMS_DES_CDS=$DATA_DIR/$PROCESSING_MODEL"_api_assignd_ims_des_cds.dta";export API_ASSIGND_IMS_DES_CDS
    API_UNSORTED_ACTD_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_unsorted_actd_output.dta";export API_UNSORTED_ACTD_FILE
  echo -e "\n#*******************************************************************#"
    echo "#                     Merge CAT1 Records                              #"
    echo "# Input Unsorted ACTD File "$API_UNSORTED_ACTD_FILE
    echo "# CAT1 File                "$API_ASSIGND_IMS_DES_CDS
    echo "# CAT1 Merged File         "$API_MERGED_CAT1_ACTD_FILE
    echo "#*******************************************************************#"
    echo "#"
    $DBGECHO sort -u -o $API_MERGED_CAT1_ACTD_FILE $API_ASSIGND_IMS_DES_CDS $API_UNSORTED_ACTD_FILE
    rc=$?


    echo "Return Code = " $rc

    if [ $rc -eq 0 ]
    then
        echo -e "\n*************************************************************"
        echo "* Successful completion of CAT1 Merge - `date`"
        echo "*************************************************************"
        errcode=0
    else

        echo -e "\n##############################################################"
        echo "# Unsuccessful Completion of CAT1 Merge - `date`"
      echo sort -u -o $API_MERGED_CAT1_ACTD_FILE $API_ASSIGND_IMS_DES_CDS $API_UNSORTED_ACTD_FILE
        echo "# Return Code "$rc
        echo "##############################################################"
        errcode=70
        echo "Errcode - "$errcode
    fi
    chmod 660 $API_MERGED_CAT1_ACTD_FILE
    return $errcode
}

sortVenc() {
 	API_SORTED_VENC_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_sorted_venc_output.dta";export API_SORTED_VENC_FILE
 	API_UNSORTED_VENC_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_unsorted_venc_output.dta";export API_UNSORTED_VENC_FILE
  echo -e "\n#*******************************************************************#"
  echo "#                 Sort VENC File or Vendor Code                       #"
  echo "# Input Unsorted VENC File "$API_UNSORTED_VENC_FILE
  echo "# Ouput Sorted VENC File "$API_SORTED_VENC_FILE
  echo "#*******************************************************************#"
  echo "#"
  $DBGECHO sort -u -o $API_SORTED_VENC_FILE $API_UNSORTED_VENC_FILE
  rc=$?


  echo "Return Code = " $rc
  if [ $rc -eq 0 ]
  then
    echo -e "\n*************************************************************"
    echo "* Successful completion of Sort - `date`"
    echo "*************************************************************"
    errcode=0
  else
    echo -e "\n##############################################################"
    echo "# Unsuccessful Completion of Sort - `date`"
    echo sort -u -o $API_SORTED_VENC_FILE $API_UNSORTED_VENC_FILE
    echo "# Return Code "$rc
    echo "##############################################################"
    errcode=70
    echo "Errcode - "$errcode
  fi
  chmod 660 $API_SORTED_VENC_FILE
  return $errcode
}

createVenn() {
  API_VENN_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_unsorted_venn_output.dta";export API_VENN_FILE
 	API_SORTED_VENC_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_sorted_venc_output.dta";export API_SORTED_VENC_FILE
  echo -e "\n#*******************************************************************#"
  echo "#                             Create VENN File                        #"
  echo "# Input VENN File "$API_SORTED_VENC_FILE
  echo "# Output VENN File "$API_VENN_FILE
  echo "# Create Delimited File - N"
  echo "#*******************************************************************#"
  echo "#"
  $DBGECHO $scm_exe/slicgldVENN -a$API_SORTED_VENC_FILE -b$API_VENN_FILE -cN -d$PROCESSING_MODEL
  rc=$?


  echo "Return Code = " $rc
  if [ $rc -eq 0 ]
  then
    echo -e "\n*************************************************************"
    echo "* Successful completion of Create VENN File - `date`"
    echo "*************************************************************"
    errcode=0
  else
    echo -e "\n##############################################################"
    echo "# Unsuccessful Completed of Create VENN File - `date`"
    echo $scm_exe/slicgldVENN -a$API_SORTED_VENC_FILE -b$API_VENN_FILE -cN -d$PROCESSING_MODEL
    echo "# Return Code "$rc
    echo "##############################################################"
    errcode=75
    echo "Errcode - "$errcode
  fi
  chmod 660 $API_VENN_FILE
  return $errcode
}

validateVendorCodes() {
  API_VENN_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_unsorted_venn_output.dta";export API_VENN_FILE
  API_GOLD_VALID_VENN_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_gold_valid_venn.dta";export API_GOLD_VALID_VENN_FILE
	API_GOLD_VENN_ERROR_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_vendor_errors.dta";export API_GOLD_VENN_ERROR_FILE
  echo -e "\n#*******************************************************************#"
  echo "#             Validate Vendor Code File against Gold"
  echo "# Input VENN File "$API_VENN_FILE
  echo "# Output Valid VENN Acty File "$API_GOLD_VALID_VENN_FILE
  echo "# Output VENN Error File "$API_GOLD_VENN_ERROR_FILE
  echo "#*******************************************************************#"
  export TWO_TASK=$SLICSRV
  echo "Processing at "$TWO_TASK
  $DBGECHO $scm_exe/slicgldVNDRcheck -a$API_VENN_FILE -b$API_GOLD_VALID_VENN_FILE -c$API_GOLD_VENN_ERROR_FILE
  rc=$?


  echo "Return Code = " $rc
  if [ $rc -eq 0 ]
  then
    export TWO_TASK=$SLICSRV
    echo -e "\n*************************************************************"
    echo "* Successful completion of Validate Vendor Activity File against Gold - `date`"
    echo -e "*\tProcessing at "$TWO_TASK
    echo "*************************************************************"
    errcode=0
  else
    echo -e "\n##############################################################"
    echo "# Unsuccessful Completed of Valide Vendor Activity File against Gold - `date`"
    echo $scm_exe/slicgldVNDRcheck -a$API_VENN_FILE -b$API_GOLD_VALID_VENN_FILE -c$API_GOLD_VENN_ERROR_FILE
    echo "# Return Code "$rc
    echo "##############################################################"
    errcode=89
    echo "Errcode - "$errcode
  fi
  chmod 660 $API_GOLD_VALID_VENN_FILE $API_GOLD_VENN_ERROR_FILE
  return $errcode
}

consolidateSegCodes() {
  API_MERGED_SC_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_merged_sc.dta";export API_SORTED_SC_FILE
	API_UNSORTED_WHSE_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_unsorted_whse_output.dta";export API_UNSORTED_WHSE_FILE
	API_UNSORTED_PRC1_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_unsorted_prc1_output.dta";export API_UNSORTED_PRC1_FILE
  echo -e "\n#*******************************************************************#"
  echo "#             Consolidate Seg Code (SC) Activity File"
  echo "# Input Unsorted Whse File "$API_UNSORTED_WHSE_FILE
  echo "# Input Unsorted Prc1 File "$API_UNSORTED_PRC1_FILE
  echo "# Sortout Consolidate SC Acty File "$API_MERGED_SC_FILE
  echo "#*******************************************************************#"
  $DBGECHO sort -u -o$API_MERGED_SC_FILE $API_UNSORTED_WHSE_FILE $API_UNSORTED_PRC1_FILE
  rc=$?


  echo "Return Code = " $rc
  if [ $rc -eq 0 ]
  then
    echo -e "\n*************************************************************"
    echo "* Successful completion of SC Activity File Sort/Merge - `date`"
    echo "*************************************************************"
    errcode=0
  else
    echo -e "\n##############################################################"
    echo "# Unsuccessful Completed of SC Activity File Sort/Merge - `date`"
    echo sort -u -o$API_MERGED_SC_FILE $API_UNSORTED_WHSE_FILE $API_UNSORTED_PRC1_FILE
    echo "# Return Code "$rc
    echo "##############################################################"
    errcode=80
    echo "Errcode - "$errcode
  fi
  chmod 660 $API_MERGED_SC_FILE
  return $errcode
}

validateSegCodes() {
  API_MERGED_SC_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_merged_sc.dta";export API_SORTED_SC_FILE
 	API_GOLD_VALID_SC_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_gold_validated_sc.dta";export API_GOLD_VALID_SC_FILE
	API_SC_ERROR_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_sc_errors.dta";export API_SC_ERROR_FILE
  echo -e "\n#*******************************************************************#"
  echo "#             Validate Seg Code (SC) Activity File against Gold"
  echo "# Input Consolidate SC Acty File "$API_MERGED_SC_FILE
  echo "# Output Validated SC Acty File "$API_GOLD_VALID_SC_FILE
  echo "# Output SC Acty Error File "$API_SC_ERROR_FILE
  echo "#*******************************************************************#"
# export TWO_TASK=$GOLDSRV
  export TWO_TASK=$SLICSRV
  echo "Processing at "$TWO_TASK
  $DBGECHO $scm_exe/slicgldSCcheck -a$API_MERGED_SC_FILE -b$API_GOLD_VALID_SC_FILE -c$API_SC_ERROR_FILE -d$PROCESSING_MODEL
  rc=$?


  echo "Return Code = " $rc
  if [ $rc -eq 0 ]
  then
    export TWO_TASK=$SLICSRV
    echo -e "\n*************************************************************"
    echo "* Successful completion of Validate Seg Code (SC) Activity File against Gold - `date`"
    echo -e "*\tProcessing at "$TWO_TASK
    echo "*************************************************************"
    errcode=0
  else
    echo -e "\n##############################################################"
    echo "# Unsuccessful Completed of Validate Seg Code (SC) Activity File against Gold - `date`"
    echo $scm_exe/slicgldSCcheck -a$API_MERGED_SC_FILE -b$API_GOLD_VALID_SC_FILE -c$API_SC_ERROR_FILE -d$PROCESSING_MODEL
    echo "# Return Code "$rc
    echo "##############################################################"
    errcode=88
    echo "Errcode - "$errcode
  fi
  chmod 660 $API_GOLD_VALID_SC_FILE $API_SC_ERROR_FILE
  return $errcode
}

createConsolidatedApiFile1() {
  API_MERGED_ACTY_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_merged_acty.dta";export API_MERGED_SLICGLD_FILE
	API_UNSORTED_CATS_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_unsorted_cats_output.dta";export API_UNSORTED_CATS_FILE
 	API_GOLD_VALID_SC_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_gold_validated_sc.dta";export API_GOLD_VALID_SC_FILE
  API_GOLD_VALID_VENN_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_gold_valid_venn.dta";export API_GOLD_VALID_VENN_FILE
  echo -e "\n#*******************************************************************#"
  echo "#             Creation of Consolidated API File "
  echo "# Input CATS File "$API_UNSORTED_CATS_FILE
  echo "# Input ACTD File "$API_UNSORTED_ACTD_FILE
  echo "# Input Validated SC Acty File "$API_GOLD_VALID_SC_FILE
  echo "# Input VENN File "$API_GOLD_VALID_VENN_FILE
  echo "# Output Merged API Activity File "$API_MERGED_ACTY_FILE
  echo "#*******************************************************************#"

  $DBGECHO  sort -u -o$API_MERGED_ACTY_FILE $API_UNSORTED_ACTD_FILE $API_UNSORTED_CATS_FILE $API_GOLD_VALID_SC_FILE $API_GOLD_VALID_VENN_FILE
  rc=$?


  echo "Return Code = " $rc
  if [ $rc -eq 0 ]
  then
    echo -e "\n*************************************************************"
    echo "* Successful Creation of Consolidated API FIle - `date`"
    echo "*************************************************************"
    errcode=0
  else
    echo -e "\n##############################################################"
    echo "# Unsuccessful Creation of Consolidated API File - `date`"
    echo sort -u -o$API_MERGED_ACTY_FILE $API_UNSORTED_ACTD_FILE $API_UNSORTED_CATS_FILE $API_GOLD_VALID_SC_FILE $API_GOLD_VALID_VENN_FILE
    echo "# Return Code "$rc
    echo "##############################################################"
    errcode=90
  fi
  chmod 660 $API_MERGED_ACTY_FILE
  return $errcode
}

createConsolidatedApiFile2() {
  API_MERGED_CAT1_ACTD_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_merged_cat1_actd_output.dta";export API_MERGED_CAT1_ACTD_FILE
  API_MERGED_ACTY_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_merged_acty.dta";export API_MERGED_SLICGLD_FILE
	API_MERGED_SLICGLD_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_merged_slicgld_acty.dta";export API_MERGED_SLICGLD_FILE
	API_NO_CAT1_ACTY_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_no_cat1_acty.dta";export API_NO_CAT1_ACTY_FILE
	API_SORTED_NO_CAT1_ACTY_FILE=$PROCESSING_MODEL"_api_sorted_no_cat1_rpt_file.dta";export API_SORTED_NO_CAT1_ACTY_FILE
  echo -e "\n#*******************************************************************#"
  echo "#             Creation of Consolidated API File "
  echo "# Input CAT1 File "$API_MERGED_CAT1_ACTD_FILE
  echo "# Input MERGED ACTY File "$API_MERGED_ACTY_FILE
  echo "# Output MERGED SLICGLD File "$API_MERGED_SLICGLD_FILE
  echo "# Output No CAT1 File File "$API_NO_CAT1_ACTY_FILE
  echo "#*******************************************************************#"
  $DBGECHO $scm_exe/slicgldAddCat1 -a$API_MERGED_CAT1_ACTD_FILE -b$API_MERGED_ACTY_FILE  -c$API_MERGED_SLICGLD_FILE -d$API_NO_CAT1_ACTY_FILE
  rc=$?


  echo "Return Code = " $rc
  if [ $rc -eq 0 ]
    then
      echo -e "\n*************************************************************"
      echo "* Successful completion of Consolidate API File - `date`"
      wc -l $API_MERGED_SLICGLD_FILE
      echo "* Sort No Catalog Report File - `date`"
      echo "# Input No CAT1 File File "$API_NO_CAT1_ACTY_FILE
      echo "# Output Sorted No CAT1 File File "$API_SORTED_NO_CAT1_ACTY_FILE
      echo "*************************************************************"
      sort -u -o$API_SORTED_NO_CAT1_ACTY_FILE $API_NO_CAT1_ACTY_FILE
      echo -e "\n*************************************************************"
      echo "* Following Part Numbers were in the API Merged Acty file that did not have a Catalog Record\n"
      wc -l $API_SORTED_NO_CAT1_ACTY_FILE
      echo "*\n"
      cat $API_SORTED_NO_CAT1_ACTY_FILE
      echo -e "\n*************************************************************"
      if [ $rc -eq 0 ]
          then
         echo -e "\n*************************************************************"
         echo "* Successful completion of SORT of No Catalog Report File - `date`"
         echo "*************************************************************"
         errcode=0
       else
         echo -e "\n##############################################################"
         echo "# Unsuccessful completion of SORT of No Catalog Report File - `date`"
         echo $scm_exe/slicgldAddCat1 -a$API_MERGED_CAT1_ACTD_FILE -b$API_MERGED_ACTY_FILE  -c$API_MERGED_SLICGLD_FILE -d$API_NO_CAT1_ACTY_FILE
         echo "# Return Code "$rc
         echo "##############################################################"
         errcode=60
         echo "Errcode - "$errcode
       fi
  else
    echo -e "\n*************************************************************"
    echo "* Unsuccessful completion of Consolidate API File - `date`"
    echo $scm_exe/slicgldAddCat1 -a$API_MERGED_CAT1_ACTD_FILE -b$API_MERGED_ACTY_FILE  -c$API_MERGED_SLICGLD_FILE -d$API_NO_CAT1_ACTY_FILE
    echo "*************************************************************"
    errcode=0
  fi
  chmod 660 $API_MERGED_SLICGLD_FILE $API_NO_CAT1_ACTY_FILE
  return $errcode
}

reorderMergedApiFile() {
	API_MERGED_SLICGLD_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_merged_slicgld_acty.dta";export API_MERGED_SLICGLD_FILE
  API_ACTY_FILE_WITH_PRIME=$DATA_DIR/$PROCESSING_MODEL"_api_acty_file_prime_parts.dta";export API_ACTY_FILE_WITH_PRIME
  API_ACTY_FILE_WITH_PARTS=$DATA_DIR/$PROCESSING_MODEL"_api_acty_file_parts.dta";export API_ACTY_FILE_WITH_PARTS
  echo -e "\n#*******************************************************************#"
  echo "#             Reorder Merged API File "
  echo "# Input Merged API Activity FIle "$API_MERGED_ACTY_FILE
  echo "# Output API Activity File w/Sortword "$API_ACTY_FILE_WITH_SORTWORD
  echo "#*******************************************************************#"
  export TWO_TASK=$SLICSRV
  echo "Processing at "$TWO_TASK
  $DBGECHO  $scm_exe/slicgldPRIME -a$API_MERGED_SLICGLD_FILE -b$API_ACTY_FILE_WITH_PRIME -c$API_ACTY_FILE_WITH_PARTS
  rc=$?


  echo "Return Code = " $rc
  if [ $rc -eq 0 ]
  then
    echo -e "\n*************************************************************"
    echo "* Successful Reorg Merged API File - `date`"
    echo "*************************************************************"
    errcode=0
  else
    echo -e "\n##############################################################"
    echo "# Unsuccessful Reorg Merged API File - `date`"
    echo $scm_exe/slicgldPRIME -a$API_MERGED_SLICGLD_FILE -b$API_ACTY_FILE_WITH_PRIME -c$API_ACTY_FILE_WITH_PARTS
    echo "# Return Code "$rc
    echo "##############################################################"
    errcode=90
  fi
  chmod 660 $API_ACTY_FILE_WITH_PRIME $API_ACTY_FILE_WITH_PARTS
  return $errcode
}

createApiFile() {
  API_ACTY_FILE_WITH_PRIME=$DATA_DIR/$PROCESSING_MODEL"_api_acty_file_prime_parts.dta";export API_ACTY_FILE_WITH_PRIME
  API_ACTY_FILE_WITH_PARTS=$DATA_DIR/$PROCESSING_MODEL"_api_acty_file_parts.dta";export API_ACTY_FILE_WITH_PARTS
  API_ACTY_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_acty_file.dta";export API_ACTY_FILE
    echo -e "\n#*******************************************************************#"
    echo "#             Create API File - Remove Prime Sortwork"
    echo "# Input Sorted API PRIME  File w/Sortword "$API_ACTY_FILE_WITH_PRIME
    echo "# Output API Activity File"$API_ACTY_FILE
    echo "#*******************************************************************#"
    $DBGECHO  cut -b3- $API_ACTY_FILE_WITH_PRIME>$API_ACTY_FILE
    rc=$?


    echo "Return Code = " $rc
    if [ $rc -eq 0 ]
    then
            echo -e "\n*************************************************************"
            echo "* Successful Sort of API File - `date`"
            echo "*************************************************************"
            echo -e "\n#*******************************************************************#"
            echo "#             Create API File - Remove Part Sortwork"
            echo "# Input Sorted API PART File w/Sortword "$API_ACTY_FILE_WITH_PARTS
            echo "# Output API Activity File Concatenated "$API_ACTY_FILE
            echo "#*******************************************************************#"
            $DBGECHO cut -b3- $API_ACTY_FILE_WITH_PARTS>>$API_ACTY_FILE
            rc=$?


            echo "Return Code = " $rc
            errcode=0
    else
            echo -e "\n##############################################################"
            echo "# Unsuccessful Sort of API File - `date`"
            echo cut -b3- $API_ACTY_FILE_WITH_PRIME>$API_ACTY_FILE
            echo "# Return Code "$rc
            echo "##############################################################"
            errcode=90
    fi
    chmod 660 $API_ACTY_FILE
  return $errcode
}

interfaceComplete() {
  API_ACTY_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_acty_file.dta";export API_ACTY_FILE
  echo -e "\n*************************************************************"
  echo "* Successful Completion of SLIC/GOLD Interface - `date`"
  echo "*************************************************************"
  echo "Completion of SLIC/GOLD Data pull - `date`"
  rcd_count=`wc -l $API_ACTY_FILE|awk '{print $1}'`
  rc=$?


  if [ $rc -eq 0 ]
  then
    if [ $rcd_count > 0 ]
    then
      echo "Completion of SLIC/GOLD Data pull"
      echo -e "\nNumber of Records in "$API_ACTY_FILE " is "$rcd_count
    else
      echo -e "\n*************************************************************"
      echo -e "\nNo Records to process in "$API_ACTY_FILE
      echo -e "\n*************************************************************"
      rc=100
    fi
  else
    echo -e "\n#############################################################"
    echo -e "\nProblem getting record count on file " $API_ACTY_FILE
    echo -e "\n#############################################################"
    errcode=101
    rc=101
  fi
  return $errcode
}

interfaceNotSuccessful() {
  echo -e "\n*************************************************************"
  echo "* UnSuccessful Completion of SLIC/GOLD Interface - `date`"
  echo "*************************************************************"
  echo "Return Code is " $rc
}

goldApiSharedTableUpdate() {
  API_ACTY_FILE=$DATA_DIR/$PROCESSING_MODEL"_api_acty_file.dta";export API_ACTY_FILE
  echo -e "\n#*******************************************************************#"
  echo "* Start of Gold API Shared Table Update - " `date`
  echo "* Processing Environment - " $PSS_ENV
  echo "#*******************************************************************#"
  export TWO_TASK=$GOLDSRV
  echo TWO_TASK=$TWO_TASK
  $DBGECHO $scm_exe/gldCATAPIU $APIDBG -a$API_ACTY_FILE -b$DATA_DIR/gldCATAPIU_error_file.dta
  rc=$?


  echo "Return Code = " $rc
  if [ $rc -eq 0 ]
  then
    export TWO_TASK=$SLICSRV
    echo -e "\n*************************************************************"
    echo "* Successful completion of Gold API Shared Table Update - `date`"
    echo -e "*\tProcessing at "$TWO_TASK
    echo "*************************************************************"
    errcode=0
  else
    echo -e "\n##############################################################"
    echo "# Unsuccessful Completion of the Gold API Shared Table Update - `date`"
    echo "# $scm_exe/gldCATAPIU $APIDBG -a$API_ACTY_FILE -b$DATA_DIR/gldCATAPIU_error_file.dta"
    echo "# Return Code "$rc
    echo "##############################################################"
    errcode=200
    echo "Errcode - "$errcode
  fi
  return $errcode
}

main() {
  if [ $stepnum -eq 0 ]
  then
    hax04
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 1 ]
  then
    ha
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 2 ]
  then
    hb
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 3 ]
  then
    hp
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 4 ]
  then
    hg
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 5 ]
  then
    sortConsolidated
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 6 ]
  then
    fmt
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 7 ]
  then
    sortDup
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 8 ]
  then
    removeDup
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 9 ]
  then
    sortPrimesAndAlt
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 10 ]
  then
    assignImsDes
    let stepnum=$stepnum+1
  fi  

  if [ $rc -eq 0 -a $stepnum -eq 11 ]
  then
    createACTD
    let stepnum=$stepnum+1
  fi


  if [ $rc -eq 0 -a $stepnum -eq 12 ]
  then
    mergeCat1
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 13 ]
  then
    sortVenc
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 14 ]
  then
    createVenn
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 15 ]
  then
    validateVendorCodes
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 16 ]
  then
    consolidateSegCodes
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 17 ]
  then
    validateSegCodes
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 18 ]
  then
    createConsolidatedApiFile1
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 19 ]
  then
    createConsolidatedApiFile2
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 20 ]
  then
    reorderMergedApiFile
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 21 ]
  then
    createApiFile
    let stepnum=$stepnum+1
  fi

  if [ $rc -eq 0 -a $stepnum -eq 22 ]
  then
    interfaceComplete
    let stepnum=$stepnum+1
  else
    if [ $rc -ne 0 -a $stepnum -eq 22 ]
    then
      interfaceNotSuccessful 
    fi
  fi

  if [ $rc -eq 0 -a $stepnum -eq 23 ]
  then
    goldApiSharedTableUpdate
  fi
  
  if [ $stepnum -gt 0 -a $stepnum -gt 23 ]
  then
    echo "Bad stepnum $stepnum"
    rc=20
  fi

  echo -e "\n##############################################################"
  echo "# Completion of SLIC/GOLD API Processing - `date`"
  echo "# Return Code Returned - $rc"
  echo "##############################################################"

  return $rc
}

menu() {

    echo "0. hax04"
    echo "1. ha"
    echo "2. hb"
    echo "3. hp"
    echo "4. hg"
    echo "5. sortConsolidated"
    echo "6. fmt"
    echo "7. sortDup"
    echo "8. removeDup"
    echo "9. sortPrimesAndAlt"
    echo "10. assignImsDes"
    echo "11. createACTD"
    echo "12. mergeCat1"
    echo "13. sortVenc"
    echo "14. createVenn"
    echo "15. validateVendorCodes"
    echo "16. consolidateSegCodes"
    echo "17. validateSegCodes"
    echo "18. createConsolidatedApiFile1"
    echo "19. createConsolidatedApiFile2"
    echo "20. reorderMergedApiFile"
    echo "21. createApiFile"
    echo "22. interfaceComplete"
    echo "23. goldApiSharedTableUpdate"

}

setup

SYSOUT=${SYSOUT:-/tmp/F15_$(date "+%Y_%m_%d_%H_%M_%S")_slicgld_output.txt}
# capture the code blocks output to a file
rm -f $SYSOUT
{
if [ "$STEP" = "fmt" ] ; then
  fmt
elif [ "$STEP" = "sortAltPrimes" ] ; then
  sortPrimesAndAlt
elif [ "$STEP" = "reorderMergedApiFile" ] ; then
  reorderMergedApiFile
elif [ "$STEP" = "menu" ] ; then
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
  echo -e "From: F15 Script\nSubject: Successful Completion of F15 SLIC/GOLD\nTo: ${RECIPIENTS}" | more $SYSOUT | sed '/^~/s/~//' | sendmail -t
else
  echo -e "From: F15 Script\nSubject: Unsuccessful Completion of F15 SLIC/GOLD\nTo: ${RECIPIENTS}" | more $SYSOUT | sed '/^~/s/~//' | sendmail -t
fi
chmod 770 $SYSOUT
chmod 770 $SYSOUT

exit $errcode 
