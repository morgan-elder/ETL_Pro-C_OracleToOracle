CC=gcc
DEBUG=
PROCOPT=
APP_HOME=${HOME}/src
INC_HOME=$(APP_HOME)/includes
CLNTSH=${ORACLE_HOME}/lib/libclntsh.so
PROD_DIR=nwlsap06.cs.boeing.com:/data/scm/c/exe
EXE_DIR=$(APP_HOME)/exe
PRECOMPINC=${ORACLE_HOME}/precomp/public/

btch45slpf : btch45slpf.o 
	$(CC) -o $(EXE_DIR)/$@ $(CLNTSH) $< -L${ORACLE_HOME}/lib \
		-L$(APP_HOME)/libs -lscm

# use the Pro*C compiler, proc, to compile a .pc file to a .c file
btch45slpf.c : btch45slpf.pc 
	proc $(PROCOPT) include=$(INC_HOME) $<

btch45slpf.o : btch45slpf.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

install:
	scp $(EXE_DIR)/btch45slpf $(PROD_DIR)/.

clean:
	rm -rf *.o *.c $(EXE_DIR)/btch45slpf
