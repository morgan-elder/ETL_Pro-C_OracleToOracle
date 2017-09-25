#!/usr/bin/ksh
# vim: ts=2:sw=2 sts=2:expandtab:
# myCompileLib.ksh
# Author: Douglas S. Elder
# Date: 9/23/14
# Desc: Compile and add routine
# to archive lib

# Rev 1.1 9/23/14 dse added -d option and fixed success literal

debug=	# default is no debug
procopt=

while getopts a:dei:l:o:v o
do	case "$o" in
  a)	APP="$OPTARG" 
      APP_LIB="$APP" ;;
  d)	debug="-D DEBUG -g " ;;
  e)	procopt="$procopt sqlcheck=semantics" ;;
  i)	INC_HOME="$OPTARG"  ;;
  l)	LIB_HOME="$OPTARG"  ;;
  o)	procopt="$procopt $OPTARG" ;;
  v)	verbose=Y ;;
	[?])	echo >&2 "Usage: $0 [ -d -e ] file ..."
		    echo >&2 "  -d turns on debug"
		    echo >&2 "  -e sets procopt to sqlcheck=semantics"
        echo >&2 "  -o pro*c command line option(s)"
        echo >&2 "     appended to current options"
		exit 1;;
	esac
done
shift $OPTIND-1



# compile the pc code if it exists
if [[  -f ${1}.pc ]] ; then
  proc $procopt include=$INC_HOME $1.pc
  if [ $? -ne 0 ] ; then
    exit $?
  fi  
fi	

if [[  ! -f ${1}.c ]] ; then
  echo ${1}.c does not exist
  exit 4
fi
gcc $debug -O -c -I /usr/oracle_cl11.2.0.3/precomp/public/ -I $INC_HOME $1.c
if [ $? -ne 0 ] ; then
  exit $?
fi  
# default to scm app
APP_LIB=${APP_LIB:-scm}
ar -r $LIB_HOME/lib${APP_LIB}.a $1.o
if [ $? -eq 0 ] ; then
  if [ "$verbose" = "Y" ] ; then
    ar -tv $LIB_HOME/lib${APP_LIB}.a
  fi
  echo "$1 successfully compiled and replaced in $LIB_HOME/lib${APP_LIB}.a"
fi
