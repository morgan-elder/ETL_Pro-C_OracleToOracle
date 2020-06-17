CC=gcc
DEBUG=
PROCOPT=
APP_HOME=${HOME}/src
INC_HOME=$(APP_HOME)/includes
CLNTSH=${ORACLE_HOME}/lib/libclntsh.so
PROD_DIR=nwlsap06.cs.boeing.com:/data/scm/c/exe
EXE_DIR=$(APP_HOME)/exe
PRECOMPINC=${ORACLE_HOME}/precomp/public/

# $< (i.e. btchv8slpf.o) must precedure all -L's and -l's to link
btchv8slpf : btchv8slpf.o 
	gcc -o $(EXE_DIR)/$@ $(CLNTSH) $< -L${ORACLE_HOME}/lib \
		-L$(APP_HOME)/libs -lscm

# compile the .pc file to make a .c file with Pro*c's proc
btchv8slpf.c : btchv8slpf.pc 
	proc $(PROCOPT) include=$(INC_HOME) $<

btchv8slpf.o : btchv8slpf.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

install:
	scp $(EXE_DIR)/btchv8slpf $(PROD_DIR)/.

clean:
	rm -rf *.o *.c $(EXE_DIR)/btchv8slpf
