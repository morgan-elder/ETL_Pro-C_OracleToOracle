export HISTFILE=/tmp/.sh_history.$LOGNAME
# stty erase ^?
stty echoe
if [ -t 0 ]
then
  stty erase ^h
fi
set -o vi

export PS1="`pwd` $ "

export ORACLE_HOME=/usr/oracle_cl11.2.0.3
export ORAPROC_INC=/usr/oracle_cl11.2.0.3/precomp/public
export CLNTSH=/usr/lib/oracle/11.2/client64/lib/libclntsh.so

#PATH=$PATH:$HOME/bin:$HOME/local/bin:/bin:/etc:/usr/bin
#PATH=$PATH:/usr/bin/X11:/usr/local/bin/_hpr:/usr/local/bin:/usr/contrib/bin
#PATH=$PATH:/appl/oracle7:/appl/psp:/appl/ief
#PATH=$PATH:/appllocal:/applusr:/mcair/user:/etc:/mcair/rel/tools/users
#PATH=$PATH:/appl/gnu/lib/bin/hppa1.1-hp-hpux:/hardcopy/util
#PATH=$PATH:/mcair/rel/appl/pjs/bin;
#PATH=$PATH:/usr/lib/X11/datebook:/usr/vue/bin:;

PATH=$PATH:$HOME/bin:/bin:/etc:/usr/local/bin:/usr/bin:/appl/prov/ext/bin:
PATH=$PATH:/usr/bin/X11:/usr/local/bin/_hpr:/usr/contrib/bin
PATH=$PATH:/appl/oracle7:/appl/psp:/appl/ief
PATH=$PATH:/appllocal:/applusr:/mcair/user:/etc:/mcair/rel/tools/users
PATH=$PATH:/appl/gnu/lib/bin/hppa1.1-hp-hpux:/hardcopy/util
PATH=$PATH:/mcair/rel/appl/pjs/bin;
PATH=$PATH:/usr/lib/X11/datebook:/usr/vue/bin:/appl/gnupg/bin:.;
PATH=$PATH:/usr/java/jdk1.7.0_45/jre/bin;
PATH=$PATH:/usr/java/jkd1.7.0_17/jre/bin;
PATH=$PATH:/opt/openv/java/jre/bin/keytool 
PATH=$PATH:$ORACLE_HOME/bin
export PATH

#Include Java
JAVA_HOME=/opt/java1.5
PATH=$PATH:$JAVA_HOME/bin
export PATH

CLASSPATH=$JAVA_HOME/lib/tools.jar:$scm_work/java/lib/ScmLib.jar:.
CLASSPATH=$CLASSPATH:/usr/oracle_cl11.2.0.3/jdbc/lib/ojdbc6.jar    
#CLASSPATH=$CLASSPATH:/usr/oracle_cl8.1.7/jdbc/lib/classes12.zip
#CLASSPATH=$CLASSPATH:/usr/oracle_cl9.2.0/jdbc/lib/ojdbc14.jar
CLASSPATH=$CLASSPATH:$scm_work/java/lib/javamail-1.3/mail.jar
CLASSPATH=$CLASSPATH:$scm_work/java/lib/jaf-1.0.2/activation.jar
export CLASSPATH

#export TERM=vt100
#typeterm=$TERM
echo Terminal Type - $typeterm
COLUMNS=82;export COLUMNS
LINES=40;export LINES

HOSTSIZE=500

echo
#
# Setup Prompt Display
#
HOSTNAME="`hostname`";export HOSTNAME
#
stty erase  kill 
stty erase 
stty erase 
stty echoe

#. .alias
ENV=~/.env
export ENV
.  $ENV
#  The following coding of /appl/prov/ext/public/set_prov_sh is so
#    applications can be tested without setting up provisionin environment
#    or the Oracle Environment.  This should not be commented out unless testing
#    is to be done where you don't want the environment.
#   
#  /appl/prov/ext/public/set_prov_sh sets both the Provisioning Environment 
#    variables and the Oracle Variables.
#
#  Uncomment after testing
#

if [ -f /mcair/rel/appl/pss_shared/public/profiler ]
  then
        . /mcair/rel/appl/pss_shared/public/profiler
fi

# common to dev & prod
alias orahome="cd $ORACLE_HOME"
alias prochome="cd $ORACLE_HOME/precomp"
export LD_LIBRARY_PATH=${ORACLE_HOME}/lib:/usr/lib/oracle/11.2/client64/lib

export PSS_SHARE_DIR=pss_shared
export REL_HOME=/mcair/rel/appl/
alias relhome="cd $REL_HOME"
export REL_PUB_HOME=$REL_HOME/$PSS_SHARE_DIR/public
alias relpub="cd $REL_PUB_HOME"

if [ "$HOSTNAME" = "svappl15" ] ; then

	export SCM_HOME=/mcair/dev/appl/scm
	alias devhome="cd $SCM_HOME"
  export SH_HOME=$SCM_HOME/sh
  alias shhome="cd $SH_HOME"
  export RUN_HOME=/data/scm
  export SH_RUN_HOME=$RUN_HOME/sh
  alias shrun="cd $SH_RUN_HOME"
  export PUB_RUN_HOME=$RUN_HOME/public
  alias shpub="cd $PUB_RUN_HOME"
	export SRC_HOME=${SCM_HOME}/work/c
	alias srchome="cd $SRC_HOME"
	export EXE_HOME=${SCM_HOME}/exe
	alias exehome="cd $EXE_HOME"
	alias fmthome="cd $SRC_HOME/slicgldFMT"
	alias libhome="cd $SRC_HOME/shared_routines"
	export INC_HOME=${SCM_HOME}/includes
	alias inchome="cd $INC_HOME"
  export INCLUDES="-I $ORAPROC_INC -I $INC_HOME"

	export LIB_HOME=${SCM_HOME}/libs
	alias archome="cd $LIB_HOME"
	export APP_LIB="scm"

	export DATA_HOME=/data/scm/TEST
	alias dathome="cd $DATA_HOME"
  PATH=$HOME/bin:${PATH}:$ORACLE_HOME/bin:$SCM_HOME/splint-3.1.1/bin:.
  export LARCH_PATH=/mcair/dev/appl/scm/splint-3.1.1/lib

elif [ "$HOSTNAME" = "svappl16" ] ; then

  export PROD_HOME=/data/scm
  alias prdhome="cd $PROD_HOME"
  export DATA_HOME=$PROD_HOME/PROD
  alias dathome="cd $DATA_HOME"
  export SH_HOME=$PROD_HOME/sh
  alias shhome="cd $SH_HOME"
  export EXE_HOME=${PROD_HOME}/c/exe
  alias exehome="cd $EXE_HOME"

  export PSS_SHARE=/mcair/rel/appl/pss_shared
  alias pssshare="cd $PSS_SHARE"
  PATH=$SH_HOME:$HOME/bin:${PATH}:$ORACLE_HOME/bin:.
  # prod scripts
  alias av8bsh="slicgld_api_av8b_sh"
  alias f15sh="slicgld_api_f15_sh"
  alias f18sh="slicgld_api_f18_sh"

fi


#clear
resize
