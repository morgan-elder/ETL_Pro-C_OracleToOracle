CC=gcc
DEBUG=
PROCOPT=
APP_HOME=${HOME}/src
INC_HOME=$(APP_HOME)/includes
CLNTSH=${ORACLE_HOME}/lib/libclntsh.so
PROD_DIR=nwlsap06.cs.boeing.com:/data/scm/c/exe
EXE_DIR=$(APP_HOME)/exe
PRECOMPINC=${ORACLE_HOME}/precomp/public/

slicgldHA : slicgldHA.o 
	gcc -o $(EXE_DIR)/$@ $(CLNTSH) $< -L${ORACLE_HOME}/lib -L$(APP_HOME)/libs -lscm

slicgldHA.c : slicgldHA.pc 
	proc $(PROCOPT) include=$(INC_HOME) $<

slicgldHA.o : slicgldHA.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

install:
	scp $(EXE_DIR)/slicgldHA $(PROD_DIR)/.

clean:
	rm -rf *.o *.c $(EXE_DIR)/slicgldHA
