CC=gcc
DEBUG=
PROCOPT=
APP_HOME=${HOME}/src
INC_HOME=$(APP_HOME)/includes
CLNTSH=${ORACLE_HOME}/lib/libclntsh.so
PROD_DIR=nwlsap06.cs.boeing.com:/data/scm/c/exe
EXE_DIR=$(APP_HOME)/exe
PRECOMPINC=${ORACLE_HOME}/precomp/public/

btch18slpf : btch18slpf.o 
	$(CC) -o $(EXE_DIR)/$@ $(CLNTSH) $< -L${ORACLE_HOME}/lib \
		-L$(APP_HOME)/libs -lscm

btch18slpf.c : btch18slpf.pc 
	proc $(PROCOPT) include=$(INC_HOME) $<

btch18slpf.o : btch18slpf.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

install:
	scp $(EXE_DIR)/btch18slpf $(PROD_DIR)/.

clean:
	rm -rf *.o *.c $(EXE_DIR)/btch18slpf
