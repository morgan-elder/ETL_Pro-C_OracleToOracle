CC=gcc
DEBUG=
PROCOPT=
APP_HOME=${HOME}/src
INC_HOME=$(APP_HOME)/includes
CLNTSH=${ORACLE_HOME}/lib/libclntsh.so
PROD_DIR=nwlsap06.cs.boeing.com:/data/scm/c/exe
EXE_DIR=$(APP_HOME)/exe
PRECOMPINC=${ORACLE_HOME}/precomp/public/

# $< (i.e. the slicgldHP.o file) must precede -L's and -l's for linker to work
slicgldHP : slicgldHP.o 
	$(CC) -o $(EXE_DIR)/$@ $(CLNTSH) $< -L${ORACLE_HOME}/lib \
		-L$(APP_HOME)/libs -lscm

slicgldHP.c : slicgldHP.pc 
	proc $(PROCOPT) include=$(INC_HOME) $<

slicgldHP.o : slicgldHP.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

install:
	scp $(EXE_DIR)/slicgldHP $(PROD_DIR)/.

clean:
	rm -rf *.o *.c $(EXE_DIR)/slicgldHP
