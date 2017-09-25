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

debug=	# default is no debug
procopt=
gccopt=

while getopts a:c:dei:l:o: o
do	case "$o" in
  a)	APP=$OPTARG 
      APP_LIB=$APP;;
  c)	gccopt=$OPTARG ;;
  d)	debug="-D DEBUG -g " ;;
  e)	procopt="$procopt sqlcheck=semantics" ;;
  i)	INC_HOME=$OPTARG ;;
  l)	LIB_HOME=$OPTARG ;;
  o)	procopt="$procopt $OPTARG" ;;
	[?])	echo >&2 "Usage: $0 [ -c gcc compile options -d -e -o pro*c options ] file ..."
		    echo >&2 "  -c gcc command line compile options"
		    echo >&2 "  -d turns on debug"
		    echo >&2 "  -e sets procopt to sqlcheck=semantics"
        echo >&2 "  -o pro*c command line option(s)"
        echo >&2 "     appended to current options"
		exit 1;;
	esac
done
shift $OPTIND-1


if [[ -f ${1}.pc ]] ; then
  proc $procopt include=$INC_HOME $1.pc
  if [ $? -ne 0 ] ; then
    exit $?
  fi  
fi	

gcc $gccopt $debug -O -c -I /usr/oracle_cl11.2.0.3/precomp/public/ -I $INC_HOME $1.c

if [ $? -ne 0 ] ; then
  exit $?
fi  
gcc -o $1 $CLNTSH $1.o -L$ORACLE_HOME/lib -L$LIB_HOME -l$APP_LIB
if [ $? -eq 0 ] ; then
  echo "$1 successfully compiled and linked"
fi
