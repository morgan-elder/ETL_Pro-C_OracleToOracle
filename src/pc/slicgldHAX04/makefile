CC=gcc
DEBUG=
PROCOPT=
APP_HOME=${HOME}/src
INC_HOME=$(APP_HOME)/includes
CLNTSH=${ORACLE_HOME}/lib/libclntsh.so
PROD_DIR=nwlsap06.cs.boeing.com:/data/scm/c/exe
EXE_DIR=$(APP_HOME)/exe
PRECOMPINC=${ORACLE_HOME}/precomp/public/

slicgldHAX04 : slicgldHAX04.o 
	gcc -o $(EXE_DIR)/$@ $(CLNTSH) $< -L${ORACLE_HOME}/lib -L$(APP_HOME)/libs -lscm

slicgldHAX04.c : slicgldHAX04.pc 
	proc $(PROCOPT) include=$(INC_HOME) $<

slicgldHAX04.o : slicgldHAX04.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

install:
	scp $(EXE_DIR)/slicgldHAX04 $(PROD_DIR)/.

clean:
	rm -rf *.o *.c $(EXE_DIR)/slicgldHAX04
