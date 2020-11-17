#!/bin/ksh
# build.ksh
# Author: Douglas S. Elder
# Date: 12/16/2019
# Desc: Build a Pro*C App
# Rev 1.0  12/16/2019  Douglas S. Elder  Initial Rev

STEP=1
SCRIPT=$(basename $0)
SRC=~/src
OBJ=~/obj
EXE_DIR=~/exe
PRO_C_DIR=$SRC/pc
C_DIR=$SRC/c

function usage {
  >&2 echo
  >&2 echo \
  "Usage: $SCRIPT [ -c c_opt -h -l link_opt -p proC_opt -s step -x ] app"
  >&2 echo "where  -c c_opt specifies any valid compile.ksh switch"
  >&2 echo "       -h this message"
  >&2 echo "       -l link_opt specifies any valid link.ksh switch"
  >&2 echo "       -m display the step menu"
  >&2 echo "       -p proC_opt specifies any valid proC.ksh switch"
  >&2 echo "       -s step where step is 1 to 3"
  >&2 echo "       -x turns on debug for this script"
  >&2 echo
}

function menu {
  echo "1. Pro*C PreProcess step"
  echo "2. Compile C        step"
  echo "3. Link             step"
  echo "4. Deploy to prod   step"
}

DEBUG=N
while getopts c:l:mp:s:x opt ; do
  case $opt in
    c) C_OPT="$OPTARG";;
    l) LINK_OPT="$OPTARG";;
    h) usage
       exit 0;;
    m) menu
       exit 0;;
    p) PRO_C_OPT="$OPTARG";;
    s) STEP=$OPTARG;;
    x) DEBUG=Y
       set -x;;
    *) usage
       exit 4;;
  esac
done
shift $((OPTIND - 1))


function main {
  [[ "$DEBUG" == "Y" ]] && set -x
  typeset APP_DIR=$1
  typeset APP=$1
  typeset RC=0

  if [ $RC -eq 0 -a $STEP -eq 1 ] ; then
    if [[ $PRO_C_DIR/${APP}/${APP}.pc -nt $C_DIR/${APP}.c ]] ; then
      proC.ksh $PRO_C_OPT $APP
      RC=$?
    else
      echo $PRO_C_DIR/${APP}/${APP}.pc is not newer than $C_DIR/${APP}.c
      RC=4
    fi
    if [ $RC -eq 0 ] ; then
      ((STEP=STEP+1))
      echo "Pro*C Preprocessor was successfull"
    else
      echo "Pro*C Preprocessor was unsuccessfull"
    fi
  fi
  if [ $RC -eq 0 -a $STEP -eq 2 ] ; then
    if [[ ! $C_DIR/${APP}.c -nt $OBJ/${APP}.o ]] ; then
      echo $C_DIR/${APP}.c is not newer than $OBJ/${APP}.o
    else
      compile.ksh $C_OPT $APP
      RC=$?
      if [ $RC -eq 0 ] ; then
        ((STEP=STEP+1))
        echo "C comiple was successfull"
      else
        echo "C compile was unsuccessfull"
      fi
    fi
  fi
  if [[ $C_OPT =~ -d ]] ; then
    $LINK_OPT="-d $LINK_OPT"
  fi
  if [ $RC -eq 0 -a $STEP -eq 3 ] ; then
    if [[ ! $OBJ/${APP}.o -nt $EXE_DIR/${APP} ]] ; then
      echo $OBJ/${APP}.o is not newer than $EXE_DIR/${APP}
      RC=4
    else
      link.ksh $LINK_OPT $APP
      RC=$?
      if [ $RC -eq 0 ] ; then
        ((STEP=STEP+1))
        echo "Link was successfull"
      else
        echo "Link was unsuccessfull"
      fi
    fi
  fi
  if [ $RC -eq 0 -a $STEP -eq 4 ] ; then
    toprod.ksh $APP
    RC=$?
    if [ $RC -eq 0 ] ; then
      ((STEP=STEP+1))
      echo "Deploy was successfull"
    else
      echo "Deploy was unsuccessfull"
    fi
  fi

  return $RC
}

# check for app
if (($#<=0)) ; then
  >&2 echo missing app
  usage
  exit 4
fi

# remove the path
APP=$(basename $1)
# remove the file extension
APP=$(echo $APP | cut -f 1 -d '.')
if [[ -f $PRO_C_DIR/${APP}.pc ]] ; then
  if [[ -d $PRO_C_DIR/${APP} ]] ; then
    if [[ $PRO_C_DIR/${APP}.pc -nt $PRO_C_DIR/${APP}/${APP}.pc ]] ; then
      mv $PRO_C_DIR/${APP}.pc $PRO_C_DIR/${APP}/.
    else
      echo found old version  $PRO_C_DIR/${APP}.pc 
      echo deleting
      rm $PRO_C_DIR/${APP}.pc $PRO_C_DIR/${APP}/.
    fi
  else
    echo directory $PRO_C_DIR/${APP} does not exist
    exit 4
  fi
fi
if [[ ! -f $PRO_C_DIR/${APP}/${APP}.pc ]] ; then
  echo $PRO_C_DIR/${APP}.pc does not exist
  exit 4
fi
 
main $APP
RC=$?
if [ $RC -eq 0 ] ; then
  echo "Build of $APP was successful"
fi
exit $RC

