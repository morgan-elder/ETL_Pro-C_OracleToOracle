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
#
THIS=$(basename $0)
# the original code was extracting the oracle_account/password@tnsname
# from this file - i.e. the account needed to run the SQL*Plus Script
PASSWORD_FILE=/home/scmftp/.srfscm
SCM_SQL="/data/scm/sql"
SQLPLUS_SCRIPT=${SCM_SQL}/sat_hotshot_request.sql

function usage {
  >&2 echo ""
  >&2 echo "Usage $THIS [ -d -h -p oracct_password_file  ]"
  >&2 echo "where optional switch -d turns on debugging"
  >&2 echo "      optional switch -h displays this message"
  >&2 echo "      optional switch -p oracct_password_file"
  >&2 echo "      overrides the default file $PASSWORD_FILE"
  >&2 echo ""
}

while getopts "dhp:" opt ; do
  case "$opt" in
    d) set -x; DEBUG=Y;;
    p) PASSWORD_FILE=$OPTARG
       if [[ ! -e $PASSWORD_FILE ]] ; then
         >&2 echo "$PASSWORD_FILE does not exist"
         usage
       fi ;;
    h) usage; exit 0;;
    *) usage; exit 4;;
  esac
done
shift $((OPTIND-1))

function setup {

  [[ "$DEBUG" == "Y" ]] && set -x

  echo "###########################################################################"
  echo "              Start SAT Hotshot Request - $(date)"
  echo "###########################################################################"
  typeset MCAIR=/mcair/rel/appl
  # source is equivalent to the dot . command
  # it just includes the code and does not issue a return code
  [[ "$DEBUG" == "Y" ]] && echo sourcing $MCAIR/pss_shared/public/set_pss_env_no_login
  source ${MCAIR}/pss_shared/public/set_pss_env_no_login

  [[ "$DEBUG" == "Y" ]] && echo sourcing /data/scm/public/setup_scm_sh
  source /data/scm/public/setup_scm_sh
  echo "Processing in Environment "$PSS_ENV

}

# input /tmp file name to be created
function prepareScript {

  typeset TEMP=$1
  typeset RC=0

  # does the file with oracle_account/password@tnsname exist?
  if [[ -e "$PASSWORD_FILE" ]] ; then
    # write oracle_account/password@tnsname and the script to $TEMP
    cat "$PASSWORD_FILE"  "$SQLPLUS_SCRIPT" > $TEMP
  else
    >&2 echo "Missing file $PASSWORD_FILE  with oracle_account/password@tnsname"
    RC=4
  fi

  return $RC
}

function main { 
  typeset RC=0 
  typeset SCM_OUT=

  setup

  if [ $PSS_ENV = "PRODN" ]
  then
    export SCM_OUT=/data/scm/PROD
  else
    export SCM_OUT=/data/scm/TEST
  fi

  typeset HOTSHOT_OUT=${SCM_OUT}/sat_hotshot_request.out

  echo ""
  echo "##################################################################"
  echo "  Loading hotshot requests to New Breed interface"
  echo "  RUNNING: $SQLPLUS_SCRIPT"
  echo "           with credentials from $PASSWORD_FILE"
  echo "  Output File: $HOTSHOT_OUT"
  echo "##################################################################"
  echo ""

  typeset TEMP=$(mktemp)

  prepareScript "$TEMP"
  RC=$?

  if ((RC==0)) ; then
    echo "Executing sqlplus -L @$TEMP $HOTSHOT_OUT"
    sqlplus -L @$TEMP $HOTSHOT_OUT
    RC=$?
    if ((RC==0)) ; then
      if [[ -e "$HOTSHOT_OUT" ]] ; then
        chmod 644 $HOTSHOT_OUT
        # all went well get rid of $TEMP
	      echo "$SQLPLUS_SCRIPT exited successfully."
        rm $TEMP
     else
	     >&2 echo "$SQLPLUS_SCRIPT failed to create $HOTSHOT_OUT"
       >&2 echo "Check $TEMP script and $HOTSHOT_OUT"
     fi
    else
      echo "sqlplus -L @$TEMP $HOTSHOT_OUT failed with RC=$RC"
    fi
  fi
  return $RC
}

LOG=$(mktemp)

set -o pipefail
main 2>&1 | tee $LOG
RC=$?
if ((RC!=0)) ; then
  echo ""
  echo "Check log $LOG for errors"
  echo ""
fi
exit $RC
