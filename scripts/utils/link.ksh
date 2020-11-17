#!/usr/bin/ksh
# vim: ts=2:sw=2 sts=2:expandtab:
# link.ksh
# Author: Douglas S. Elder
# Date: 12/15/2019
# Desc: link obj's and lib's to make an exe
# application
# the script looks for 
# Rev 1.0 12/15/2019 initial rev

DEBUG=	# used to debug this script
GCCOPT=
OBJ_HOME=$HOME/obj
EXE_HOME=$HOME/exe
if [[ -d $HOME/lib ]] ; then
  LIB_HOME=-L$HOME/lib
else
  LIB_HOME=
fi

if [[ -f  ${ORACLE_HOME}/lib/libclntsh.so ]] ; then
  PRO_C_LIB=${ORACLE_HOME}/lib/libclntsh.so
else
  echo Pro*C lib ${ORACLE_HOME}/lib/libclntsh.so does not exist
fi

function usage {
  >&2 echo ""
  >&2 echo "Usage: $0 [ -g gcc_options -d ] exe_file"
  >&2 echo "  -c gcc command line compile options"
  >&2 echo "  -d turns on debug"
  >&2 echo ""
}

LINKOPT=
while getopts a:de:g:l:x o
do	case "$o" in
  a)	APP=$OPTARG 
      APP_LIB=$APP;;
  d)	LINKOPT="-D DEBUG -g ";;
  e)	EXTRA_LIB="$OPTARG";;
  g)	GCCOPT=$OPTARG ;;
  l)	LIB_HOME=$OPTARG ;;
  x)	set -x
      DEBUG=Y;;
  [?]) usage
       exit 1;;
	esac
done
shift $OPTIND-1

if (($#<=0)) ; then
  usage
  exit 4
fi


function link_module {
  [[ "$DEBUG" == "Y" ]] && set -x
  typeset APP=$1
  typeset RC=0
  if [[ -f $OBJ_HOME/${APP}.o ]] ; then
    gcc $LINKOPT -L$ORACLE_HOME/lib -L$LIB_HOME $PRO_C_LIB \
      -o $EXE_HOME/$APP \
      $OBJ_HOME/${APP}.o 
    RC=$?
    if [ $RC -eq 0 ] ; then
      chmod 770 $EXE_HOME/$APP
    fi
  else
    echo $OBJ_HOME/${APP}.o does not exist
    RC=4
  fi
  return $RC
}

APP=$(basename $1)
APP=$(echo $APP | cut -f 1 -d '.')
link_module $APP
RC=$?
if [ $RC -eq 0 ] ; then
  echo $1 successfully linked
else
  >&2 echo failed to link $1 with RC=$RC
fi
exit $RC
