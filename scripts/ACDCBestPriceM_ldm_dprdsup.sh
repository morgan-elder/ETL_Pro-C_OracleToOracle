#!/bin/sh
. /mcair/rel/appl/pss_shared/public/set_pss_env_no_login
. /data/scm/public/setup_scm_sh

email_out=/tmp/ACDCBestPrice_M_out.txt

echo "----------------------------------------------------------------">$email_out
echo "--- Build ACDC Best Price Table `date`                     -----">>$email_out
echo "---          ACDCBestPrice.sh                              -----">>$email_out
echo "----------------------------------------------------------------">>$email_out

####################################################################################
#export TWO_TASK=stl_prodsup01
####################################################################################

echo "Command being executed - "$0>>$email_out
echo "Arguments being Passed - "$*>>$email_out
echo "Number of Arguments "$#>>$email_out
echo "PSS_DB  "$PSS_DB>>$email_out
echo "PSS_ENV  "$PSS_ENV>>$email_out
echo "HOSTNAME "`hostname`>>$email_out

echo "TWO_TASK "$TWO_TASK

if [ $PSS_ENV = "TEST" ]
    then
    echo "Processing Test" $PSS_ENV
    PARMFILE=/home/scmftp;export PARMFILE
    export dta_scm=$dta_scm/TEST
else
    echo "Processing Production" $PSS_ENV
    PARMFILE=/home/scmftp;export PARMFILE
#    export dta_scm=$dta_scm/PROD
    export dta_scm=$dta_scm/TEST
fi


echo "Data Directory " $dta_scm
echo "SQL FILE "$scm_sql

####################################################################################
FISCAL_PERIOD=FY11
PROCESSING_MDL=AV8B
####################################################################################


rc=0

SQLFILE=$scm_sql/.ACDCBestPrice_sqlfile.sql

echo "#----------------------------------------------------------------------------------------#">>$email_out
echo "#------------ Extract Part/MFG Codes from ACDC Data Table `date` ------------------------#">>$email_out
echo "#----------------------------------------------------------------------------------------#">>$email_out
echo "#----------------------------------------------------------------------------------------#"
echo "#------------ Extract Part/MFG Codes from ACDC Data Table `date` ------------------------#"
echo "#----------------------------------------------------------------------------------------#"
SCHEMA=`cat /home/scmftp/.SCM_destn`
ACCESS=`cat /home/scmftp/.SCM_pass`
CONNECT=$SLICSRV
ACDC_EXTRACTED_PARTS=$dta_scm/ACDCBestPrice_Extracted_Parts.txt
echo "Extracted ACDC Parts "$ACDC_EXTRACTED_PARTS
echo "Extracted ACDC Parts "$ACDC_EXTRACTED_PARTS>>$email_out
more $scm_sql/ACDCBestPrice_get_parts_M.sql| 
			sed 's/MYSCHEMA/'$SCHEMA'/g'|
			sed 's/ACCESS/'$ACCESS'/g'|
			sed 's/CONNECT/'$CONNECT'/g'>$SQLFILE
#cat $SQLFILE
#sqlplus -s @$SQLFILE $ACDC_EXTRACTED_PARTS
rc=$?
if [ $rc -ne 0 ]
   then
	rc=100
	echo "*******************************************************************************">>$email_out
	echo "***      Abnormal Termination of SQL Pull of Basic Part Info `date`         ***">>$email_out
	echo "*******************************************************************************">>$email_out
	echo "*******************************************************************************"
	echo "***      Abnormal Termination of SQL Pull of Basic Part Info `date`         ***"
	echo "*******************************************************************************"
else
	wc -l $ACDC_EXTRACTED_PARTS
	wc -l $ACDC_EXTRACTED_PARTS>>$email_out
	echo "*******************************************************************************">>$email_out
	echo "***      Successful Completion of SQL Pull of Basic Part Info `date`        ***">>$email_out
	echo "*******************************************************************************">>$email_out
	echo "*******************************************************************************"
	echo "***      Successful Completion of SQL Pull of Basic Part Info `date`        ***"
	echo "*******************************************************************************"
        rm $SQLFILE
fi

if [ $rc -eq 0 ]
  then
	echo "#----------------------------------------------------------------------------------------#">>$email_out
	echo "#------------ Extract Best Price from ACDC Data Table `date` ------------------------------#">>$email_out
	echo "#----------------------------------------------------------------------------------------#">>$email_out
	echo "#----------------------------------------------------------------------------------------#"
	echo "#------------ Extract Best Price from ACDC Data Table `date` ----------------------------#"
	echo "#----------------------------------------------------------------------------------------#"
	ACDC_EXTRACTED_BEST_PRICE_PARTS=$dta_scm/ACDCBestPrice_Parts.txt
	echo "Input Extracted ACDC Parts "$ACDC_EXTRACTED_PARTS
	echo "Input Extracted ACDC Parts "$ACDC_EXTRACTED_PARTS>>$email_out
	echo "Output Extracted ACDC Best Price Parts "$ACDC_EXTRACTED_BEST_PRICE_PARTS
	echo "Output Extracted ACDC Best Price Parts "$ACDC_EXTRACTED_BEST_PRICE_PARTS>>$email_out

#	$scm_exe/ACDCBestPriceM -a$ACDC_EXTRACTED_PARTS -b$ACDC_EXTRACTED_BEST_PRICE_PARTS -c$FISCAL_PERIOD>>$email_out
	rc=$?
	if [ $rc -eq 0 ]
	  then
		wc -l $ACDC_EXTRACTED_BEST_PRICE_PARTS
		wc -l $ACDC_EXTRACTED_BEST_PRICE_PARTS>>$email_out
		echo "*******************************************************************************">>$email_out
		echo "***      Sucessful Completion of Extract Best Price Info `date`             ***">>$email_out
		echo "*******************************************************************************">>$email_out
		echo "*******************************************************************************"
		echo "***      Sucessful Completion of Extract Best Price Info `date`             ***"
		echo "*******************************************************************************"
	else
		rc=110
		echo "*******************************************************************************">>$email_out
		echo "***      Abnormal Termination of Extract Best Price Info `date`             ***">>$email_out
		echo "*******************************************************************************">>$email_out
		echo "*******************************************************************************"
		echo "***      Abnormal Termination of Extract Best Price Info `date`             ***"
		echo "*******************************************************************************"
	fi
fi

if [ $rc -eq 0 ]
  then
	echo "#----------------------------------------------------------------------------------------#">>$email_out
	echo "#------------ Extract PBOM No Order Part `date`           -------------------------------#">>$email_out
	echo "#----------------------------------------------------------------------------------------#">>$email_out
	echo "#----------------------------------------------------------------------------------------#"
	echo "#------------ Extract PBOM No Order Part `date`           -------------------------------#"
	echo "#----------------------------------------------------------------------------------------#"
	ACDC_EXTRACTED_NO_ORDER_PARTS=$dta_scm/ACDCBestPrice_NoOrder_Parts.txt
	echo "Output Extracted ACDC No Order Parts "$ACDC_EXTRACTED_NO_ORDER_PARTS
	echo "Output Extracted ACDC No Order Parts "$ACDC_EXTRACTED_NO_ORDER_PARTS>>$email_out

#	$scm_exe/ACDCNoOrderPartsM -a$ACDC_EXTRACTED_NO_ORDER_PARTS -b$FISCAL_PERIOD -c$PROCESSING_MDL>>$email_out
	rc=$?
	if [ $rc -eq 0 ]
	  then
		wc -l $ACDC_EXTRACTED_NO_ORDER_PARTS>>$email_out
		wc -l $ACDC_EXTRACTED_NO_ORDER_PARTS
		echo "*******************************************************************************">>$email_out
		echo "***      Sucessful Completion of Extract No Ordered Parts `date`            ***">>$email_out
		echo "*******************************************************************************">>$email_out
		echo "*******************************************************************************"
		echo "***      Sucessful Completion of Extract No Ordered Parts `date`            ***"
		echo "*******************************************************************************"
	else
		rc=115
		echo "*******************************************************************************">>$email_out
		echo "***      Abnormal Termination of Extract No Ordered Parts `date`            ***">>$email_out
		echo "*******************************************************************************">>$email_out
		echo "*******************************************************************************"
		echo "***      Abnormal Termination of Extract No Ordered Parts `date`            ***"
		echo "*******************************************************************************"
	fi
fi

if [ $rc -eq 0 ]
  then
	echo "#----------------------------------------------------------------------------------------#">>$email_out
	echo "#------------ Consolidate No Order and Best Price Data `date` ---------------------------#">>$email_out
	echo "#----------------------------------------------------------------------------------------#">>$email_out
	echo "#----------------------------------------------------------------------------------------#"
	echo "#------------ Consolidate No Order and Best Price Data `date` ---------------------------#"
	echo "#----------------------------------------------------------------------------------------#"
	ACDC_CONSOLIDATED_BEST_PRICE_PARTS=$dta_scm/ACDCBestPrice_Consolidate_Priced_Parts.txt
	echo "Input Extracted ACDC No Order Parts "$ACDC_EXTRACTED_NO_ORDER_PARTS
	echo "Input Extracted ACDC No Order Parts "$ACDC_EXTRACTED_NO_ORDER_PARTS>>$email_out
	echo "Input Extracted ACDC Best Price Parts "$ACDC_EXTRACTED_BEST_PRICE_PARTS
	echo "Input Extracted ACDC Best Price Parts "$ACDC_EXTRACTED_BEST_PRICE_PARTS>>$email_out
	echo "Output Consolidated Pricing Record "$ACDC_CONSOLIDATED_BEST_PRICE_PARTS
	echo "Output Consolidated Pricing Record "$ACDC_CONSOLIDATED_BEST_PRICE_PARTS>>$email_out

	sort -o$ACDC_CONSOLIDATED_BEST_PRICE_PARTS $ACDC_EXTRACTED_BEST_PRICE_PARTS $ACDC_EXTRACTED_NO_ORDER_PARTS
	rc=$?
	if [ $rc -eq 0 ]
	  then
		wc -l $ACDC_CONSOLIDATED_BEST_PRICE_PARTS
		wc -l $ACDC_CONSOLIDATED_BEST_PRICE_PARTS>>$email_out
		echo "*******************************************************************************">>$email_out
		echo "***      Sucessful Completion of Consolidate Pricing Records `date`         ***">>$email_out
		echo "*******************************************************************************">>$email_out
		echo "*******************************************************************************"
		echo "***      Sucessful Completion of Consolidate Pricing Records `date`         ***"
		echo "*******************************************************************************"
	else
		rc=120
		echo "*******************************************************************************">>$email_out
		echo "***      Abnormal Termination of Consolidate Pricing Records `date`         ***">>$email_out
		echo "*******************************************************************************">>$email_out
		echo "*******************************************************************************"
		echo "***      Abnormal Termination of Consolidate Pricing Records `date`         ***"
		echo "*******************************************************************************"
	fi
fi

if [ $rc -eq 0 ]
  then
	echo "#----------------------------------------------------------------------------------------#">>$email_out
	echo "#------------ Load ACDC Best Price Table Pass 1 `date`   --------------------------------#">>$email_out
	echo "#----------------------------------------------------------------------------------------#">>$email_out
	echo "#----------------------------------------------------------------------------------------#"
	echo "#------------ Load ACDC Best Price Table Pass 1 `date`    -------------------------------#"
	echo "#----------------------------------------------------------------------------------------#"
	DATAFILE=$ACDC_CONSOLIDATED_BEST_PRICE_PARTS;export DATAFILE 
	CTLFILE=$scm_home/load/ACDC_Best_Price_multi.ctl;export CTLFILE
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
	echo "Data Base Machine "$PSS_DB

	if [ -f $DATAFILE ]
  	 then
#             . /home/oracle/scripts/oracle_cl10.2.0_setup.sh
		export TWO_TASK=stl_dprdsup
	     sqlldr parfile=$PARMFILE/scm_parm_file control=$CTLFILE, log=$LOGFILE
             rc=$?
             if [ $rc -eq 0 ]
		then
			echo "\r\t********************************">>$email_out
			echo "\r\tSuccessful load of ACDC Best Prices Pass 1 `date`">>$email_out
			echo "\r\t********************************">>$email_out
			echo "\r\t********************************"
			echo "\r\tSuccessful load of ACDC Best Prices Pass 1 `date`"
			echo "\r\t********************************"
			cat $LOGFILE>>$email_out
			cat $LOGFILE
			rc=0
		else
			echo "\r\t????????????????????????????????">>$email_out
			echo "\r\tUnsuccessful load of ACDC Best Prices Pass 1 `date`">>$email_out
			echo "\r\t????????????????????????????????">>$email_out
			echo "\r\t????????????????????????????????"
			echo "\r\tUnsuccessful load of ACDC Best Prices Pass 1 `date`"
			echo "\r\t????????????????????????????????"
			rc=20
	    fi
	else
		echo "Unable to locate load file " $DATAFILE>>$email_out
		rc=21
	fi
fi

if [ $rc -eq 0 ]
  then
	echo "#----------------------------------------------------------------------------------------#">>$email_out
	echo "#------------ Extract Other Part/MFG Codes from Gold Data Table `date` ------------------#">>$email_out
	echo "#----------------------------------------------------------------------------------------#">>$email_out
	echo "#----------------------------------------------------------------------------------------#"
	echo "#------------ Extract Other Part/MFG Codes from Gold Data Table  `date` -----------------#"
	echo "#----------------------------------------------------------------------------------------#"
	SCHEMA=`cat /home/scmftp/.stlscm_DESTN`
	ACCESS=`cat /home/scmftp/.stlscm_PASS`
	CONNECT=$SLICSRV
	ACDC_EXTRACTED_OTHER_PARTS=$dta_scm/ACDCBestPrice_Extracted_Other_Parts.txt
	ACDC_EXTRACTED_OTHER_PARTS_SORTED=$dta_scm/ACDC_Extracted_Other_Parts_Sorted.txt
	echo "Extracted Other ACDC Parts "$ACDC_EXTRACTED_OTHER_PARTS
	echo "Extracted Other ACDC Parts "$ACDC_EXTRACTED_OTHER_PARTS>>$email_out
	more $scm_sql/ACDCOtherPartsM.sql| 
			sed 's/MYSCHEMA/'$SCHEMA'/g'|
			sed 's/ACCESS/'$ACCESS'/g'|
			sed 's/CONNECT/'$CONNECT'/g'>$SQLFILE

#	cat $SQLFILE
#	sqlplus -s @$SQLFILE $ACDC_EXTRACTED_OTHER_PARTS
	rc=$?
	if [ $rc -ne 0 ]
	   then
		rc=116
		echo "*******************************************************************************">>$email_out
		echo "***      Abnormal Termination of SQL Pull of Basic Part Info `date`         ***">>$email_out
		echo "*******************************************************************************">>$email_out
		echo "*******************************************************************************"
		echo "***      Abnormal Termination of SQL Pull of Basic Part Info `date`         ***"
		echo "*******************************************************************************"
	else
		echo "*******************************************************************************">>$email_out
		echo "***      Successful Completion of SQL Pull of Basic Part Info `date`        ***">>$email_out
		echo "*******************************************************************************">>$email_out
		echo "*******************************************************************************"
		echo "***      Successful Completion of SQL Pull of Basic Part Info `date`        ***"
		echo "*******************************************************************************"
       		rm $SQLFILE
		echo "*******************************************************************************">>$email_out
		echo "***      Suppress Dupes in Other Part Extract `date`                        ***">>$email_out
		echo "*******************************************************************************">>$email_out
		echo "*******************************************************************************"
		echo "***      Suppress Dupes in Other Part Extract `date`                        ***"
		echo "*******************************************************************************"
		wc -l $ACDC_EXTRACTED_OTHER_PARTS
		wc -l $ACDC_EXTRACTED_OTHER_PARTS>>$email_out
		ACDC_EXTRACTED_OTHER_PARTS_SORTED=$dta_scm/ACDCBestPrice_Extracted_Other_Parts_Sorted.txt
		echo "Extracted Other ACDC Parts Sorted "$ACDC_EXTRACTED_OTHER_PARTS_SORTED
		echo "Extracted Other ACDC Parts Sorted "$ACDC_EXTRACTED_OTHER_PARTS_SORTED>>$email_out
#		sort -u -o$ACDC_EXTRACTED_OTHER_PARTS_SORTED $ACDC_EXTRACTED_OTHER_PARTS
		rc=$?
		if [ $rc -eq 0 ]
		   then
			echo "*******************************************************************************">>$email_out
			echo "***      Successful Completion of Extract of Other Parts `date`             ***">>$email_out
			echo "*******************************************************************************">>$email_out
			echo "*******************************************************************************"
			echo "***      Successful Completion of Extract of Other Parts `date`             ***"
			echo "*******************************************************************************"
			wc -l $ACDC_EXTRACTED_OTHER_PARTS_SORTED
			wc -l $ACDC_EXTRACTED_OTHER_PARTS_SORTED>>$email_out
		else
			rc=117
			echo "*******************************************************************************">>$email_out
			echo "***      Abnormal Completion of Extract of Other Parts `date`               ***">>$email_out
			echo "*******************************************************************************">>$email_out
			echo "*******************************************************************************"
			echo "***      Abnormal Completion of Extract of Other Parts `date`               ***"
			echo "*******************************************************************************"
		fi
	fi
fi

if [ $rc -eq 0 ]
  then
	echo "#----------------------------------------------------------------------------------------#">>$email_out
	echo "#------------ Process ACDC Other Parts `date`             -------------------------------#">>$email_out
	echo "#----------------------------------------------------------------------------------------#">>$email_out
	echo "#----------------------------------------------------------------------------------------#"
	echo "#------------ Process ACDC Other Parts `date`             -------------------------------#"
	echo "#----------------------------------------------------------------------------------------#"
	ACDC_EXTRACTED_OTHER_SLIC_PRICED_PARTS=$dta_scm/ACDCBestPrice_Extracted_Other_Parts_SLIC.txt
	echo "Input Extracted ACDC Parts "$ACDC_EXTRACTED_OTHER_PARTS_SORTED
	echo "Input Extracted ACDC Parts "$ACDC_EXTRACTED_OTHER_PARTS_SORTED>>$email_out
	echo "Output Extracted ACDC Best Price Parts "$ACDC_EXTRACTED_OTHER_SLIC_PRICED_PARTS
	echo "Output Extracted ACDC Best Price Parts "$ACDC_EXTRACTED_OTHER_SLIC_PRICED_PARTS>>$email_out

#	$scm_exe/ACDCOtherPartsM -a$ACDC_EXTRACTED_OTHER_PARTS_SORTED -b$ACDC_EXTRACTED_OTHER_SLIC_PRICED_PARTS -c$FISCAL_PERIOD -d$PROCESSING_MDL>>$email_out
	rc=$?
	if [ $rc -eq 0 ]
	  then
		wc -l $ACDC_EXTRACTED_OTHER_SLIC_PRICED_PARTS>>$email_out
		wc -l $ACDC_EXTRACTED_OTHER_SLIC_PRICED_PARTS
		echo "*******************************************************************************">>$email_out
		echo "***      Sucessful Completion of ACDC Other Part Pricing `date`             ***">>$email_out
		echo "*******************************************************************************">>$email_out
		echo "*******************************************************************************"
		echo "***      Sucessful Completion of ACDC Other Part Pricing `date`             ***"
		echo "*******************************************************************************"
	else
		rc=110
		echo "*******************************************************************************">>$email_out
		echo "***      Abnormal Termination of ACDC Other Part Pricing `date`             ***">>$email_out
		echo "*******************************************************************************">>$email_out
		echo "*******************************************************************************"
		echo "***      Abnormal Termination of ACDC Other Part Pricing `date`             ***"
		echo "*******************************************************************************"
	fi
fi

if [ $rc -eq 0 ]
  then
	echo "#----------------------------------------------------------------------------------------#">>$email_out
	echo "#------------ Consolidate No Order Best Price Data and Other Parts  `date` --------------#">>$email_out
	echo "#----------------------------------------------------------------------------------------#">>$email_out
	echo "#----------------------------------------------------------------------------------------#"
	echo "#------------ Consolidate No Order Best Price Data and Other Parts `date` ---------------#"
	echo "#----------------------------------------------------------------------------------------#"
	ACDC_CONSOLIDATED_ALL_PARTS=$dta_scm/ACDCBestPrice_Consolidate_ALL_Priced_Parts.txt
	echo "Input Extracted ACDC No Order Parts "$ACDC_EXTRACTED_NO_ORDER_PARTS
	echo "Input Extracted ACDC No Order Parts "$ACDC_EXTRACTED_NO_ORDER_PARTS>>$email_out
	echo "Input Extracted ACDC Best Price Parts "$ACDC_EXTRACTED_BEST_PRICE_PARTS
	echo "Input Extracted ACDC Best Price Parts "$ACDC_EXTRACTED_BEST_PRICE_PARTS>>$email_out
	echo "Input Extracted Other ACDC Parts Sorted "$ACDC_EXTRACTED_OTHER_SLIC_PRICED_PARTS
	echo "Input Extracted Other ACDC Parts Sorted "$ACDC_EXTRACTED_OTHER_SLIC_PRICED_PARTS>>$email_out
	echo "Output Consolidated All Pricing Record "$ACDC_CONSOLIDATED_ALL_PARTS
	echo "Output Consolidated All Pricing Record "$ACDC_CONSOLIDATED_ALL_PARTS>>$email_out

#	sort -u -o$ACDC_CONSOLIDATED_ALL_PARTS $ACDC_EXTRACTED_BEST_PRICE_PARTS $ACDC_EXTRACTED_NO_ORDER_PARTS $ACDC_EXTRACTED_OTHER_SLIC_PRICED_PARTS
	rc=$?
	if [ $rc -eq 0 ]
	  then
		wc -l $ACDC_CONSOLIDATED_ALL_PARTS
		wc -l $ACDC_CONSOLIDATED_ALL_PARTS>>$email_out
		echo "*******************************************************************************">>$email_out
		echo "***      Sucessful Completion of Consolidate ALL Pricing Records `date`     ***">>$email_out
		echo "*******************************************************************************">>$email_out
		echo "*******************************************************************************"
		echo "***      Sucessful Completion of Consolidate ALL Pricing Records `date`     ***"
		echo "*******************************************************************************"
	else
		rc=120
		echo "*******************************************************************************">>$email_out
		echo "***      Abnormal Termination of Consolidate ALL Pricing Records `date`     ***">>$email_out
		echo "*******************************************************************************">>$email_out
		echo "*******************************************************************************"
		echo "***      Abnormal Termination of Consolidate ALL Pricing Records `date`     ***"
		echo "*******************************************************************************"
	fi
fi
if [ $rc -eq 0 ]
  then
	echo "#----------------------------------------------------------------------------------------#">>$email_out
	echo "#------------ Load ACDC Best Price Table Pass 2 `date`    -------------------------------#">>$email_out
	echo "#----------------------------------------------------------------------------------------#">>$email_out
	echo "#----------------------------------------------------------------------------------------#"
	echo "#------------ Load ACDC Best Price Table Pass 2 `date`    -------------------------------#"
	echo "#----------------------------------------------------------------------------------------#"
	DATAFILE=$ACDC_CONSOLIDATED_ALL_PARTS;export DATAFILE 
	CTLFILE=$scm_home/load/ACDC_Best_Price_multi.ctl;export CTLFILE
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
#             . /home/oracle/scripts/oracle_cl10.2.0_setup.sh
#	     sqlldr parfile=$PARMFILE/scm_parm_file control=$CTLFILE, log=$LOGFILE
             rc=$?
             if [ $rc -eq 0 ]
		then
			echo "\r\t*******************************************">>$email_out
			echo "\r\tSuccessful load of ACDC Best Prices Pass 2 `date`">>$email_out
			echo "\r\t*******************************************">>$email_out
			echo "\r\t*******************************************"
			echo "\r\tSuccessful load of ACDC Best Prices Pass 2 `date`"
			echo "\r\t******************************************"
			rc=0
			cat $LOGFILE>>$email_out
			cat $LOGFILE
		else
			echo "\r\t????????????????????????????????">>$email_out
			echo "\r\tUnsuccessful load of ACDC `date` ">>$email_out
			echo "\r\t????????????????????????????????">>$email_out
			echo "\r\tReturn Code $rc"
			echo "\r\t????????????????????????????????"
			echo "\r\tUnsuccessful load of ACDC `date` "
			echo "\r\t????????????????????????????????"
			rc=20
	    fi
	else
		echo "Unable to locate load file " $DATAFILE>>$email_out
		rc=21
	fi
fi


echo "---------------------------------------------------------------------------"
echo "--- ACDC Build Best Price Table completion `date`                     -----"
echo "--- Return Code " $rc
echo "---------------------------------------------------------------------------"
echo "---------------------------------------------------------------------------">>$email_out
echo "--- ACDC Build Best Price Table completion `date`                     -----">>$email_out
echo "--- Return Code " $rc>>$email_out
echo "---------------------------------------------------------------------------">>$email_out

if [ $rc -eq 0 ]
    then
	rm $dta_scm/ACDC/acdc_HISS_table_loads.txt
	more $email_out|mailx -m -s"Successful Completion Test ACDC Load Best Price Table" larry.d.mills@boeing.com
else
	more $email_out|mailx -m -s"Abnormal Termination Test ACDC Load Best Price Table" larry.d.mills@boeing.com
fi
exit $rc
