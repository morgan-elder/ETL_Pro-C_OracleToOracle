#!/bin/ksh
# sat_hotshot_request.sh
#  
#	change history
#
#	date		who		change
#	04/30/2009	Doug Meyer	Created New.
#	12/18/2020	Douglas S. Elder	Tried to make it more usable
#                               NOTE: file with oracle_account/password@tnsname
#                               is missing - see PASSWORD_FILE below
#                               The changes made enable this script to be
#                               more generic and execute a SQL*Plus script
#                               for any db
#
THIS=$(basename $0)
# the original code was extracting the oracle_account/password@tnsname
# from this file - i.e. the account needed to run the SQL*Plus Script
BIN=/data/scm/sh
export PATH=$BIN:$PATH
if [[ -e $BIN/debug.txt ]] ; then
  DEBUG=$(cat $BIN/debug.txt)
  [[ "$DEBUG" == "Y" ]] && set -x
fi
# set defaults
PASSWORD_FILE=/home/scmftp/.srfscm
SQL_DIR="/data/scm/sql"
SQLPLUS_SCRIPT=${SQL_DIR}/sat_hotshot_request.sql
APPL=/APPL/rel/appl

# source is equivalent to the dot . command
# it just includes the code and does not issue a return code
[[ "$DEBUG" == "Y" ]] && echo sourcing $APPL/pss_shared/public/set_pss_env_no_login
source ${APPL}/pss_shared/public/set_pss_env_no_login

[[ "$DEBUG" == "Y" ]] && echo sourcing /data/scm/public/setup_scm_sh
source /data/scm/public/setup_scm_sh

if [[ $PSS_ENV == "PRODN" ]] ; then
  OUT_DIR=/data/scm/PROD
else
  OUT_DIR=/data/scm/TEST
fi
OUT_FILE=${OUT_DIR}/sat_hotshot_request.out
echo "Processing in Environment "$PSS_ENV



function usage {
  >&2 echo ""
  >&2 echo "Usage $THIS [ -d -h -o fileout -p oracct_password_file -s script  ]"
  >&2 echo "where optional switch -d turns on debugging"
  >&2 echo "      optional switch -h displays this message"
  >&2 echo "      optional switch -o fileout output from the"
  >&2 echo "      SQL*Plus script will override $OUT_FILE"
  >&2 echo "      optional switch -p oracct_password_file"
  >&2 echo "      overrides the default file $PASSWORD_FILE"
  >&2 echo "      optional switch -s script"
  >&2 echo "      overrides the default file $SQLPLUS_SCRIPT"
  >&2 echo "      script must specify the full path or path"
  >&2 echo "      relative to the current working directory"
  >&2 echo ""
}

while getopts "dho:p:s:" opt ; do
  case "$opt" in
    d) set -x; DEBUG=Y;;
    o) OUT_FILE=$OPTARG;;
    p) PASSWORD_FILE=$OPTARG
       if [[ ! -e $PASSWORD_FILE ]] ; then
         >&2 echo "$PASSWORD_FILE does not exist"
         usage
       fi ;;
    h) usage; exit 0;;
    s) SQLPLUS_SCRIPT=$OPTARG
       if [[ ! -e $SQLPLUS_SCRIPT ]] ; then
         >&2 echo "$SQLPLUS_SCRIPT does not exist"
         usage
       fi ;;
    *) usage; exit 4;;
  esac
done
shift $((OPTIND-1))


# input /tmp file name to be created
function prepareScript {

  typeset TEMP=$1
  typeset RC=0

  # does the file with oracle_account/password@tnsname exist?
  if [[ -e "$PASSWORD_FILE" ]] ; then
    # write oracle_account/password@tnsname and the script to $TEMP
    cat "$PASSWORD_FILE" "$SQLPLUS_SCRIPT"  > $TEMP
  else
    >&2 echo "Missing file $PASSWORD_FILE  with oracle_account/password@tnsname"
    RC=4
  fi

  return $RC
}

function showMsg {
  typeset ACTION=$1
  echo "###########################################################################"
  echo "              $ACTION SAT Hotshot Request - $(date)"
  echo "###########################################################################"
}

function main { 
  typeset RC=0 

  showMsg "Start"

  echo ""
  echo "##################################################################"
  echo "  RUNNING: $SQLPLUS_SCRIPT"
  echo "           with credentials from $PASSWORD_FILE"
  echo "  Output File: $OUT_FILE"
  echo "##################################################################"
  echo ""

  typeset TEMP=$(mktemp).sql

  prepareScript "$TEMP"
  RC=$?

  if ((RC==0)) ; then
    [[ "$DEBUG" == "Y" ]] && echo "Executing sqlplus -L @$TEMP $OUT_FILE"
    sqlplus -L @$TEMP $OUT_FILE
    RC=$?
    if ((RC==0)) ; then
      if [[ -e "$OUT_FILE" ]] ; then
        chmod 644 $OUT_FILE
        # all went well get rid of $TEMP
	      echo "$SQLPLUS_SCRIPT exited successfully. (see $OUT_FILE)"
        rm $TEMP
     else
	     >&2 echo "$SQLPLUS_SCRIPT failed to create $OUT_FILE"
       >&2 echo "Check $TEMP script and $OUT_FILE"
     fi
    else
      echo "sqlplus -L @$TEMP $OUT_FILE failed with RC=$RC"
    fi
  fi

  echo ""

  showMsg "End"

  return $RC
}

LOG=$(mktemp).log

set -o pipefail
main 2>&1 | tee $LOG
RC=$?
echo ""
echo "log $LOG created"
echo ""
exit $RC
