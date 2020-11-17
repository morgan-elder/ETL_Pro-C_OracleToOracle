#!/usr/bin/ksh
# vim: ts=2:sw=2 sts=2:expandtab:
# myCompileLink.ksh
# Author: Douglas S. Elder
# Date: 9/23/14
# Desc: Compile and Link a Pro*C
# application
# the parameter must be the name of the program
# to compile without the file extension
# the script looks for 
# Rev 1.0 9/4/14 initial rev
# Rev 1.1 9/23/14 dse added -d option and fixed success literal

THIS=$(basename $0)
DATA=$HOME/data
if [[ -f $DATA/debug.txt ]] ; then
  DEBUG=$(cat $DATA/debug.txt)
else
  DEBUG=N
fi
[[ "$DEBUG" == "Y" ]] && set -x
CDEBUG=	# used to set compiler debug options
COPT="-O"
procopt=
gccopt=
OBJ_HOME=$HOME/obj
if [[ ! -d $OBJ_HOME ]] ; then
  mkdir $OBJ_HOME
  chmod 770 $OBJ_HOME
fi
EXE_HOME=$HOME/exe
if [[ ! -d $EXE_HOME ]] ; then
  mkdir $EXE_HOME
  chmod 770 $EXE_HOME
fi

# this directory must exist
if [[ -d $HOME/src ]] ; then
  export SRC_HOME=$HOME/src
else
  echo SRC_HOME=$HOME/src does not exist
  exit 4
fi



# invoke Oracle's Pro*C precompiler for embedded SQL
# INC_HOME may be set in ~/.profile if the SCM includes exists
function pro_c {
  [[ "$DEBUG" == "Y" ]] && set -x
  typeset APP=$1
  typeset SRC=$2
  typeset OPT=
  if [[ "$INC_HOME" != "" ]] ; then
    OPT="INCLUDE=${INC_HOME}"
  fi
  proc $procopt $OPT INCLUDE=$HOME/src/includes \
                PARSE=NONE CODE=ANSI_C ERRORS=NO LNAME=${APP}.lis \
                ONAME=$C_HOME/${APP}.c INAME=$SRC
  return $?
}

# INC_HOME may be set in ~/.profile if the SCM includes exists
function c_compile {
  [[ "$DEBUG" == "Y" ]] && set -x
  typeset APP=$1
  typeset OPT=
  if [[ "$INC_HOME" != "" ]] ; then
    OPT="-I${INC_HOME}"
  fi
  echo 
  if [[ "$DEBUG" == "Y" ]] ; then
    echo "compiling $C_HOME/${APP}.c"
    echo gcc $gccopt $CDEBUG $COPT -c -I$HOME/src/includes -v \
      -I$ORACLE_HOME/precomp/public $OPT \
      -o $OBJ_HOME/${APP}.o \
         $C_HOME/${APP}.c
  fi

  gcc $gccopt $CDEBUG $COPT -c -I$HOME/src/includes -v \
      -I$ORACLE_HOME/precomp/public $OPT \
      -o $OBJ_HOME/${APP}.o \
         $C_HOME/${APP}.c
  return $?
}

# LIB_HOME may be set in ~/.profile if the SCM lib exists
function link_module {
  [[ "$DEBUG" == "Y" ]] && set -x
  typeset APP=$1
  typeset OPT=
  if [[ "${LIB_HOME:-}" != "" ]] ; then
    OPT="-L${LIB_HOME}"
  fi

  if [[ "$DEBUG" == "Y" ]] ; then
    echo "linking $OBJ_HOME/${APP}.o"
    echo gcc -o $EXE_HOME/$APP $CLNTSH \
      $OBJ_HOME/${APP}.o \
      -L$ORACLE_HOME/lib $OPT
  fi

  gcc -o $EXE_HOME/$APP $CLNTSH \
    $OBJ_HOME/${APP}.o \
    -L$ORACLE_HOME/lib $OPT
  return $?
}


function setupSrc {
  [[ "$DEBUG" == "Y" ]] && set -x
  typeset APP=$1
  typeset SRC=
  typeset RC=0

  # is it a Pro*C app in its own directory
  if [[ -f $SRC_HOME/pc/${APP}/${APP}.pc ]] ; then
    SRC=$SRC_HOME/pc/${APP}/${APP}.pc
  # is it a Pro*C app in the pc directory
  elif [[ -f $SRC_HOME/pc/${APP}.pc ]] ; then
    SRC=$SRC_HOME/pc/${APP}.pc
  # is it a C app 
  elif [[ -f $C_HOME/${APP}.c ]] ; then
    SRC=$C_HOME/${APP}.c
  else 
    >&2 echo "Unable to determine source"
    RC=4
  fi
  echo $SRC
  return $RC
}

function main {
  [[ "$DEBUG" == "Y" ]] && set -x
  typeset APP=$1
  typeset RC=0

  typeset SRC=$(setupSrc $APP)
  RC=$?
  if ((RC==0)) ; then
    # do we need to translate Pro*C to C?
    if [[ "$SRC" =~ .*\.pc$ ]] ; then 
      pro_c $APP $SRC
      RC=$?
      if ((RC==0)) ; then
        echo "Pro*C was successfull for $APP"
      else
        echo "Pro*C was NOT successfull for $APP"
      fi
    fi
  fi

  if ((RC==0)) ; then
    c_compile $APP
    RC=$?
    if ((RC==0)) ; then
      link_module $APP
      RC=$?
      if ((RC==0)) ; then
        echo "$APP successfully compiled and linked at $(date)"
      else
        >&2 echo "failed to link $APP"
      fi
    else
      >&2 echo "failed to compile $APP"
    fi
  fi
} 

function usage {
  >&2 echo "Usage: $THIS [ -c gcc compile options -d -e -o pro*c options ] file ..."
  >&2 echo "  -c gcc command line compile options"
  >&2 echo "  -d turns on debug"
  >&2 echo "  -e sets procopt to sqlcheck=semantics"
  >&2 echo "  -o pro*c command line option(s)"
  >&2 echo "     appended to current options"
  >&2 echo "  -s src_dir"
}

while getopts a:c:dei:l:o:s:x o
do	case "$o" in
  a)	APP=$OPTARG 
      APP_LIB=$APP;;
  c)	gccopt=$OPTARG ;;
  d)	CDEBUG=" -DDEBUG -g "
      COPT=" -O0 ";;
  e)	procopt="$procopt sqlcheck=semantics" ;;
  i)	INC_HOME=$OPTARG ;;
  l)	LIB_HOME=$OPTARG ;;
  o)	procopt="$procopt $OPTARG" ;;
  s)	SRC_HOME=$OPTARG ;;
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

LOG=$(mktemp)
main $1 2>&1 | tee $LOG
