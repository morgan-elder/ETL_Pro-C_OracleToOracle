CC=gcc
DEBUG=
PROCOPT=
SCM_HOME=${HOME}/src
INC_HOME=$(SCM_HOME)/includes
CLNTSH=${ORACLE_HOME}/lib/libclntsh.so
PROD_DIR=nwlsap06.cs.boeing.com:/data/scm/c/exe
EXE_DIR=$(SCM_HOME)/exe
PRECOMPINC=${ORACLE_HOME}/precomp/public/

slicgldPRIME : slicgldPRIME.o 
	$(CC) -o $(EXE_DIR)/$@ $(CLNTSH) $< -L${ORACLE_HOME}/lib \
		-L$(SCM_HOME)/libs -lscm

slicgldPRIME.c : slicgldPRIME.pc 
	proc $(PROCOPT) include=$(INC_HOME) $<

slicgldPRIME.o : slicgldPRIME.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

install:
	scp $(EXE_DIR)/slicgldPRIME $(PROD_DIR)/.

clean:
	rm -rf *.o *.c $(EXE_DIR)/slicgldPRIME
