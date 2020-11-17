# Copyright (c) 1993 - 2011 The Boeing Company.  All rights reserved.
# vim: ts=2:sw=2:sts=2:et:syntax=sh:
#
#	@(#) .profile 2.3.7 1.28 96/07/19 11:08:28 98/10/16 12:32:46 
#
# User customizable sh/ksh command script read at beginning of every login
# Bourne (sh) or Korn (ksh) shell.
#
# For gory documentation details, see the end of this file
# (moved there to not obscure the code).

#---------------------------------------------------------------------

# Let USA Environment master .profile do its thing first.

if [ -z "${__USA_EnvRoot}" ]; then
    # no system USA_env; try portable USA_env
    if [ -d "$HOME/.USA_env" ]; then
	__USA_EnvRoot=$HOME/.USA_env		# for portable USA_env
	export   __USA_EnvRoot
	readonly __USA_EnvRoot

	# When USA Environment is installed on a system, /etc/profile
	# sources /opt/USA_env/etc/USA_profile, so mimic that here

	if [ -r "${__USA_EnvRoot}/etc/USA_profile" ]; then
	    . "${__USA_EnvRoot}/etc/USA_profile"
	fi
    fi
fi

if [ -r "${__USA_EnvRoot}/user/master.profile" ]; then
    . "${__USA_EnvRoot}/user/master.profile"
fi

host=`hostname -s`
# common to dev & prod
export ORACLE_HOME=/usr/oracle_cl11.2.0.3
export CLNTSH=/usr/lib/oracle/11.2/client64/lib/libclntsh.so
alias orahome="cd $ORACLE_HOME"
alias prochome="cd $ORACLE_HOME/precomp"
export LD_LIBRARY_PATH=${ORACLE_HOME}/lib:/usr/lib/oracle/11.2/client64/lib

if [ "$host" = "svappl15" ] ; then

	export MS2_HOME=/mcair/dev/appl/prov
	alias devhome="cd $MS2_HOME"
  export SH_HOME="$MS2_HOME/sh"
  alias shhome="cd $SH_HOME"
	export SRC_HOME=${MS2_HOME}/work/c
	alias srchome="cd $SRC_HOME"
	export EXE_HOME=${MS2_HOME}/exe
	alias exehome="cd $EXE_HOME"
	alias libhome="cd $SRC_HOME/shared"
	export INC_HOME=${MS2_HOME}/includes
	alias inchome="cd $INC_HOME"
	export LIB_HOME=${MS2_HOME}/libs
	alias archome="cd $LIB_HOME"
  export APP_LIB="prov"
	export DATA_HOME=/data/prov/TEST
	alias dathome="cd $DATA_HOME"
  PATH=$HOME/bin:${PATH}:$ORACLE_HOME/bin:.

elif [ "$host" = "svappl16" ] ; then

  export PROD_HOME=/data/prov
  alias prdhome="cd $PROD_HOME"
  export DATA_HOME=$PROD_HOME/PROD
  alias dathome="cd $DATA_HOME"
  export SH_HOME=/data/gmics/db2m/prov/sh
  alias shhome="cd $SH_HOME"
  export EXE_HOME=${PROD_HOME}/c/exe
  alias exehome="cd $EXE_HOME"

  export PSS_SHARE=/mcair/rel/appl/pss_shared
  alias pssshare="cd $PSS_SHARE"
  PATH=$SH_HOME:$HOME/bin:${PATH}:$ORACLE_HOME/bin:.
  # prod scripts - TBD
  # alias av8bsh="slicgld_api_av8b_sh"
  # alias f15sh="slicgld_api_f15_sh"
  # alias f18sh="slicgld_api_f18_sh"

fi

# file max line sizes 
alias fz="fileSizes.ksh"
# compile and link apps
alias mycl="myCompileLink.ksh"
alias mycld="myCompileLink.ksh -d"
# compile subroutines
alias mycsub="myCompileLib.ksh"



#---------------------------------------------------------------------

# At this point you have a choice for your personal customizations:
#
#   1. customizing this file ($HOME/.profile) in place, or
#
#   2. putting your customizations in a separate file
#      (e.g. $HOME/.profile.custom).
#
# If you ever re-install the USA user environment user-level files in your
# home directory, this file will be overwritten (after first being copied
# to a "save" subdirectory).  If you have customized this file, those
# customizations will be lost unless you again customize this file.  A way
# to minimize the effort of doing that is to put your customizations in a
# separate file (e.g. $HOME/.profile.custom) and then source that file from
# this file.
#
# If you choose the .profile.custom approach, you can find a template
# in /opt/USA_env/user/.profile.custom.
#
# If you choose not to use the $HOME/.profile.custom approach, you can
# delete the code below and replace it with whatever you wish, possibly
# incorporating the body of /opt/USA_env/user/.profile.custom as a
# starting point.

# Possibly execute user customizations, if kept in a separate file.

if [ -r "${HOME}/.profile.custom" ]; then
    . "${HOME}/.profile.custom"
fi

#---------------------------------------------------------------------

# Gory documentation details...  delete from here to end of file if you wish

####
#
# FILE NAME:	.profile
#
# PURPOSE:	User customizable sh/ksh command script read at beginning
#		of execution of login Bourne (sh) and Korn (ksh) shells.
#
# ENTRY:	Sourced by the Bourne or Korn shell.
#
#		A new login Bourne or Korn shell process is starting.
#
#		If it exists, /etc/profile has already been read and
#		executed, which in turn has already read and executed
#		/opt/USA_env/etc/USA_profile.
#
#		No commands have yet been read from the shell input
#		file, script, or from the "-c" command line option.
#
#		The following environment variables are defined:
#
#		USER
#		LOGNAME
#		    Depending on which system we are running on, one
#		    or both of these are already defined to hold the
#		    user's login name.
#
#		OPENWINHOME
#		    Set to path where OpenWindows is installed (SunOS only).
#
#		STAC_ROOT
#		    Set to path where STAC is installed.
#
#		EDITOR
#		FCEDIT
#		VISUAL
#		    All set to use vi as the editor.
#
#		MAIL
#		    Set to path of your mail spool file.
#
#		PATH
#		    Set to standard USA path for this platform.
#
#		MANPATH
#		    Set to standard USA path for this platform.
#
#		TERM
#		    Set to some (possibly invalid) terminal type.  It may
#		    have arbitrary data appended to it, separated by a |
#		    character, which will be stripped after the original
#		    TERM value is copied to the __TERM variable.  This
#		    behavior is supported in order to accomodate people
#		    who append additional information to the TERM variable
#		    before invoking telnet, which propagates the TERM
#		    variable to the remote session - this technique is
#		    often used to automatically communicate additional
#		    information to a telnet session.
#
#		PS1
#		    Set to prompt for input with the host name
#		    and next command sequence number.
#
#		ENV_FILE
#		    Set to "$HOME/.kshrc".
#
#		ENV
#		    Set to conditionally expand to either null, if this
#		    Korn shell is not interactive, or to the contents
#		    of the ENV_FILE environment variable, if this Korn
#		    shell is interactive.
#
#		__USA_EnvRoot
#		    Path of the directory where USA startup files reside.
#
#		__USA_SessionLog
#		    Path of the session log file to which we can write.
#
#		The following environment variables may or may not be
#		defined:
#
#		__USA_UnameN
#		    Results reported by "uname -n" (host name).
#
#		If this shell is part of a USA X-Windows session, the
#		following environment variables are defined:
#
#		DISPLAY
#		    The display name of the X server we are using
#		    (may be in symbolic (names) or numeric IP form).
#
#		DISPLAY_IP
#		    The display name, in numeric IP form, of the X
#		    server we are using.
#
#		If possible (not all systems recognize all of these)
#		the terminal settings are set to the USA standard
#		terminal settings:
#
#		    brkint
#		    hupcl
#		    ignpar
#		    istrip
#		    erase '^H'
#		    flush '^O'
#		    discard '^O'
#		    intr '^C'
#		    kill '^U'
#		    lnext '^V'
#		    quit '^\'
#		    rprnt '^R'
#		    reprint '^R'
#		    susp '^Z'
#		    dsusp '^Y'
#		    werase '^W'
#		    stop '^S'
#		    start '^Q'
#		    eof '^D'
#		    eol '^@'
#		    eol2 '^@'
#		    swtch <undefined>
#
# EXIT:		The following environment variables are set:
#
#		PS1
#		    Set to prompt for input with the host name
#		    and next command sequence number.
#
#		ENV
#		    Set to "$HOME/.kshrc".
#
#		__TERM
#		    Original value of TERM variable.
#
#		TERM
#		    Stripped of any '|' character and all characters that
#		    follow the '|', then the remainder is validated against
#		    terminal types known to this system, and if necessary,
#		    the user is prompted for a valid terminal type.
#
#		    This behavior is provided to accomodate people who
#		    append additional information to the TERM variable
#		    before invoking telnet or rlogin, which propagate the
#		    TERM variable to the remote session - this technique
#		    is often used to automatically communicate additional
#		    information to a telnet or rlogin session (for example,
#		    the DISPLAY environment variable in an X-Window session).
#
# USES:		No shell variables are used, other than those
#		discussed in the EXIT documentation, and those
#		used by /opt/USA_env/etc/tty_init.
#
# CALLS:	/opt/USA_env/user/master.profile
#		$HOME/.profile.custom
#
# DESCRIPTION:	The default $HOME/.profile provided by USA simply reads and
#		executes a two other files which partition .profile's work
#		into a system-defined piece (/opt/USA_env/user/master.profile),
#		which allows a system administrator to provide a common
#		baseline for all users, and a user-specific piece
#		($HOME/.profile.custom), which allows you to provide your
#		own personal customizations.  Because .profile resides in
#		your home directory you are at liberty to change this
#		file in any way you desire - your participation in this
#		scheme is entirely voluntary.  If you don't like what
#		the master .profile file does, don't use it (possibly
#		incorporate its contents into this file or into the
#		$HOME/.profile.custom file and edit it to suit your tastes).
#
#		Login Bourne and Korn shells read a system profile
#		file (/etc/profile) (which in turn reads the
#		/opt/USA_env/etc/USA_profile file to set up a standard
#		USA user environment), then this file ($HOME/.profile),
#		which provides a way for you to tailor your environment.
#		Even if your login shell is a C shell, if your $HOME/.login
#		file sources the /opt/USA_env/etc/USA_login script, this file
#		will end up being executed during the login process (see
#		comments in /opt/USA_env/etc/USA_login for details).
#
#		Define and export your environment variables here.  Any
#		definitions that are made and exported in this file are
#		made available to all subsequent processes.  This file
#		is executed each time you log in.  On USA systems it will
#		be executed for all shells (csh, ksh, sh).  It is best to
#		use Bourne shell commands in this file.
#
# NOTE:		If you ever re-install the USA user environment default
#		user-level files in your home directory, this file will
#		be overwritten (after first being copied to a "save"
#		subdirectory).  If you have customized this file, those
#		customizations will be lost unless you again customize
#		this file.  A way to minimize the effort of doing that
#		is to put your customizations in a separate file (e.g.
#		$HOME/.profile.custom) and then source that file from this
#		file.  Then the customization process for a new version of
#		this file is simply adding one line to source your
#		customization file.
#
# HISTORY:
#
# 10/31/94	Complete rewrite to partition functionality into a
#		master .profile (/opt/USA_env/user/master.profile) and
#		into a user customization .profile ($HOME/.profile.custom).
#		Conrad Kimball.
#
# 04/30/96	Move bulk of documentation to end of file, to not
#		obscure the code.
#		Conrad Kimball.
#
# 05/26/2011	Changes for "portable" USA User Environment;
#		1) set __USA_EnvRoot to first directory we find in
#		this list: /opt/USA_env, $HOME/.USA_env;
#		2) source ${__USA_EnvRoot}/etc/USA_profile if using
#		the "portable" USA environment (to mimic what would
#		happen with a system-installed USA environment);
#		Conrad Kimball.

####################################################################
##								  ##
##	Before modifying this file, please acquaint yourself	  ##
##	with the shell programming notes in the file:		  ##
##								  ##
##	$HOME/.USA_env/etc/shell_programming_notes.Z		  ##
##								  ##
####################################################################

#---------------------------------------------------------------------

# NOTE: Because this script must be executable by both Bourne and Korn
#	shells, limit yourself to Bourne shell facilities unless you
#	first explicitly test for the Korn shell.
#
# NOTE: Because this script is sourced by another script, it _shares_
#	the environment of that script.  Thus, you have access to,
#	and can modify, any part of that script's environment.  If
#	you are not careful you can break the parent script by
#	damaging shell variables, functions, or other elements of
#	the environment that it expects to remain intact while this
#	script runs.

if [ -t 0 ]
then
  stty erase ^h
fi
stty rows 60
PS1='${PWD}> '
