#!/usr/bin/ksh
# vim: ts=2:sw=2 sts=2:expandtab:
# proC.ksh
# Author: Douglas S. Elder
# Date: 12/13/19
# Desc: Preprocess a Pro*C source file (.pc extension)
# and create a c or cpp output file
# Rev 1.0 12/13/19 initial rev

SCRIPT=$(basename $0)
HOST=$(hostname -s)
DEBUG=	# used to debug this script
PROCOPT=
if [[ -d ~/src ]] ; then
  export SRC=~/src
else
  echo SRC=~/src does not exist
  exit 4
fi
if [[ -d $SRC/pc ]] ; then
  PRO_C_HOME=$SRC/pc
else
  echo "directory SRC/pc does not exist"
  exit 4
fi
C_HOME=$SRC/c
if [[ ! -d $C_HOME ]] ; then
  mkdir $C_HOME
  chmod 770 $C_HOME
fi
if [[ -d $SRC/includes ]] ; then
  INC_HOME=$SRC/includes
else
  echo "directory $SRC/includes does not exist"
  exit 4
fi

function usage {
  >&2 echo ""
  >&2 echo "Usage: $SCRIPT -d -e -i dir -o Pro*C_OPT app"
  >&2 echo "  -d turn on debugging for the script"
  >&2 echo "  -e turn on sqlcheck option for Pro*C"
  >&2 echo "  -i dir an additonal include library"
  >&2 echo "  -o pro*c command line option(s)"
  >&2 echo "     appended to current options"
  >&2 echo "  app the application to be compiled"
  >&2 echo "    it should be in $PRO_C_HOME/app directory"
  >&2 echo "    and be app.pc within that directory"
  >&2 echo "    where app is the filename without the .pc extension"
  >&2 echo ""
}

while getopts dei:o:x o
do	case "$o" in
  a)	APP=$OPTARG 
      APP_LIB=$APP;;
  c)	gccopt=$OPTARG ;;
  d)	DEBUG=Y
      set -x;;
  e)	PROCOPT="$PROCOPT sqlcheck=semantics" ;;
  i)	INC_HOME=$OPTARG ;;
  o)	PROCOPT="$PROCOPT $OPTARG" ;;
  [?]) usage
       exit 1;;
	esac
done
shift $((OPTIND-1))

if (($#<=0)) ; then
  usage
  exit 4
fi
APP=$1
if [[ -d $PRO_C_HOME/$APP ]] ; then
  APP_DIR=$PRO_C_HOME/$APP
else
  >&2 echo "directory $PRO_C_HOME/$APP does not exist"
  exit 4
fi
if [[ ! -f $APP_DIR/${APP}.pc ]] ; then
  echo file "$APP_DIR/${APP}.pc does not exist"
  exit 4
fi

# invoke Oracle's Pro*C precompiler for embedded SQL
# INC_HOME is set in ~/.profile .. it is the SCM includes
function pro_c {
  [[ "$DEBUG" == "Y" ]] && set -x
  typeset LIST=$APP_DIR/${APP}.lis
  typeset RC=0
  touch $LIST
  if [[ -f $C_HOME/${APP}.c ]] ; then
    echo removing $C_HOME/${APP}.c
    rm $C_HOME/${APP}.c
  fi
  proc $PROCOPT INCLUDE=${INC_HOME} \
                INCLUDE=$APP_DIR \
                LNAME=${LIST} \
                ONAME=$C_HOME/${APP}.c \
                INAME=$APP_DIR/$APP
  RC=$?
  if [ $RC -eq 0 ] && [[ -f $C_HOME/${APP}.c ]] ; then
    echo "succussfully compiled ${APP}.pc"
    echo "created $C_HOME/${APP}.c"
    dos2unix $C_HOME/${APP}.c
  else
    echo "Pro*C had 1 or more errors.  Check ${LIST}"
  fi
  return $RC
}

pro_c 
exit $?
