CC=gcc
DEBUG=
PROCOPT=
APP_HOME=${HOME}/src
PC=$(APP_HOME)/pc
PCFILES=$(PC)/*.pc
C=$(APP_HOME)/c
OBJ=$(APP_HOME)/obj
OBJFILES=$(PCFILES:.pc=.o)
INC_HOME=$(APP_HOME)/includes
CLNTSH=${ORACLE_HOME}/lib/libclntsh.so
PROD_DIR=nwlsap06.cs.boeing.com:/data/APP/c/exe
EXE_DIR=$(APP_HOME)/exe
PRECOMPINC=${ORACLE_HOME}/precomp/public/

all: 
	+$(MAKE) -C shared_routines $(TARGET)
	+$(MAKE) -C pc/btch18slpf $(TARGET)
	+$(MAKE) -C pc/btchv8slpf $(TARGET)
	+$(MAKE) -C pc/btch45slpf $(TARGET)
	+$(MAKE) -C pc/gldCATAPIU $(TARGET)
	+$(MAKE) -C pc/slicgldACTD $(TARGET)
	+$(MAKE) -C pc/slicgldAddCat1 $(TARGET)
	+$(MAKE) -C pc/slicgldCAT1 $(TARGET)
	+$(MAKE) -C pc/slicgldFMT $(TARGET)
	+$(MAKE) -C pc/slicgldHA $(TARGET)
	+$(MAKE) -C pc/slicgldHAX04 $(TARGET)
	+$(MAKE) -C pc/slicgldHB $(TARGET)
	+$(MAKE) -C pc/slicgldHG $(TARGET)
	+$(MAKE) -C pc/slicgldHP $(TARGET)
	+$(MAKE) -C pc/slicgldPRIME $(TARGET)
	+$(MAKE) -C pc/slicgldSCcheck $(TARGET)
	+$(MAKE) -C pc/slicgldVENN $(TARGET)
	+$(MAKE) -C pc/slicgldVNDRcheck $(TARGET)
