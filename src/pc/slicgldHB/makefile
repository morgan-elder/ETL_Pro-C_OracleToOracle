CC=gcc
DEBUG=
PROCOPT=
SCM_HOME=${HOME}/src
INC_HOME=$(SCM_HOME)/includes
CLNTSH=${ORACLE_HOME}/lib/libclntsh.so
PROD_DIR=nwlsap06.cs.boeing.com:/data/scm/c/exe
EXE_DIR=$(SCM_HOME)/exe
PRECOMPINC=${ORACLE_HOME}/precomp/public/

slicgldHB : slicgldHB.o 
	gcc -o $(EXE_DIR)/$@ $(CLNTSH) $< -L${ORACLE_HOME}/lib -L$(SCM_HOME)/libs -lscm

slicgldHB.c : slicgldHB.pc 
	proc $(PROCOPT) include=$(INC_HOME) $<

slicgldHB.o : slicgldHB.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

install:
	scp $(EXE_DIR)/slicgldHB $(PROD_DIR)/.

clean:
	rm -rf *.o *.c $(EXE_DIR)/slicgldHB
