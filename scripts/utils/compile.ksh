#!/usr/bin/ksh
# vim: ts=2:sw=2 sts=2:expandtab:
# compile.ksh
# Author: Douglas S. Elder
# Date: 12/13/19
# Desc: Compile a C app and create an object file
# Automatically determine if the app is a Pro*C app
# by checking for the sqlca used by such app's
# Rev 1.0 12/13/19 initial rev

SCRIPT=$(basename $0)
DEBUG= # used to debug this script
debug= # used for the gcc compiler
GCCOPT=
PRO_C_INC=$ORACLE_HOME/precomp/public
if [[ ! -d $PRO_C_INC ]] ; then
  echo "Pro*C Include directory, $PRO_C_INC does not exist"
  exit
fi
SRC=$HOME/src/c
if [[ ! -d $SRC ]] ; then
  >&2 echo $SRC directory does not exist
  exit 4
fi
INC=$HOME/src/includes
if [[ ! -d $INC ]] ; then
  >&2 echo $INC directory does not exist
  exit 4
fi

OBJ=$HOME/obj
if [[ ! -d $OBJ ]] ; then
  mkdir $OBJ
  chmod 770 $OBJ
fi

function usage {
  >&2 echo ""
  >&2 echo "Usage: $SCRIPT [ -c gcc_opts -d -i inc_dir -x ] app"
  >&2 echo "  -c gcc command line compile options"
  >&2 echo "  -d compile with DEBUG"
  >&2 echo "  -i inc_dir adds an additonal include directory for the"
  >&2 echo "     compile"
  >&2 echo "  -x turns on script debugging"
  >&2 echo ""
}

while getopts c:di:x o
do	case "$o" in
  c)	GCCOPT=$OPTARG ;;
  d)	debug="-D DEBUG -g " ;;
  i)	INC_DIR=$OPTARG
      if [[ ! -d $INC_DIR ]] ; then
        echo "$INC_DIR directory does not exist"
        exit 4
      fi ;;
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

function c_compile {
  [[ "$DEBUG" == "Y" ]] && set -x
  typeset APP=$1
  typeset EXTRA_INC=
  if [[ -n $INC_DIR ]] ; then
    EXTRA_INC="$EXTRA_INC -I$INC_DIR"
  fi
  grep -q -i "sqlca" $C_HOME/${APP}.c
  if [ $? -eq 0 ] ; then
    EXTRA_INC="$EXTRA_INC -I$PRO_C_INC"
  fi

  echo "gcc $GCCOPT $debug -D __linux__ -O -c -I$INC -v \
      -I$ORACLE_HOME/precomp/public/ \
      $EXTRA_INC $C_HOME/${APP}.c \
      -o $OBJ/${APP}.o"
  gcc $GCCOPT $debug -D __linux__ -O -c -I$INC -v \
      -I$ORACLE_HOME/precomp/public/ \
      $EXTRA_INC $C_HOME/${APP}.c \
      -o $OBJ/${APP}.o
  return $?
}

APP=$(basename $1)
APP=$(echo $APP | cut -f 1 -d '.')

if [[ ! -f $C_HOME/${APP}.c ]] ; then
  echo "$C_HOME/${APP}.c does not exist"
  exit 4
fi

c_compile $APP
exit $?
