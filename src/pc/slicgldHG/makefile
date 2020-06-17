CC=gcc
DEBUG=
PROCOPT=
APP_HOME=${HOME}/src
INC_HOME=$(APP_HOME)/includes
CLNTSH=${ORACLE_HOME}/lib/libclntsh.so
PROD_DIR=nwlsap06.cs.boeing.com:/data/scm/c/exe
EXE_DIR=$(APP_HOME)/exe
PRECOMPINC=${ORACLE_HOME}/precomp/public/

# $< must precede all -L's and -l for linker to work
slicgldHG : slicgldHG.o 
	gcc -o $(EXE_DIR)/$@ $(CLNTSH) $< -L${ORACLE_HOME}/lib -L$(APP_HOME)/libs -lscm

slicgldHG.c : slicgldHG.pc 
	proc $(PROCOPT) include=$(INC_HOME) $<

slicgldHG.o : slicgldHG.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

install:
	scp $(EXE_DIR)/slicgldHG $(PROD_DIR)/.

clean:
	rm -rf *.o *.c $(EXE_DIR)/slicgldHG
