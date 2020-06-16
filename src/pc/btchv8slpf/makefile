CC=gcc
DEBUG=
PROCOPT=
SCM_HOME=${HOME}/src
INC_HOME=$(SCM_HOME)/includes
CLNTSH=${ORACLE_HOME}/lib/libclntsh.so
PROD_DIR=nwlsap06.cs.boeing.com:/data/scm/c/exe
EXE_DIR=$(SCM_HOME)/exe
PRECOMPINC=${ORACLE_HOME}/precomp/public/

btchv8slpf : btchv8slpf.o 
	gcc -o $@ $(CLNTSH) $@.o -L$(ORACLE_HOME)/lib -L$(SCM_HOME)/libs -lscm
	cp $@ $(EXE_DIR)/$@

btchv8slpf.c : btchv8slpf.pc $(INC_HOME)/gold685_cat1_api.h  $(INC_HOME)/GetTime.h
	proc $(PROCOPT) include=$(INC_HOME) $<

btchv8slpf.o : btchv8slpf.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

install:
	scp btchv8slpf $(PROD_DIR)/.

clean:
	rm -rf *.o *.c btchv8slpf
