CC=gcc
DEBUG=
PROCOPT=
SCM_HOME=${HOME}/src
INC_HOME=$(SCM_HOME)/includes
CLNTSH=${ORACLE_HOME}/lib/libclntsh.so
PROD_DIR=nwlsap06.cs.boeing.com:/data/scm/c/exe
EXE_DIR=$(SCM_HOME)/exe
PRECOMPINC=${ORACLE_HOME}/precomp/public/

slicgldSCcheck : slicgldSCcheck.o 
	gcc -o $@ $(CLNTSH) $@.o -L$(ORACLE_HOME)/lib -L$(SCM_HOME)/libs -lscm
	cp $@ $(EXE_DIR)/$@

slicgldSCcheck.c : slicgldSCcheck.pc $(INC_HOME)/gold685_cat1_api.h  $(INC_HOME)/GetTime.h
	proc $(PROCOPT) include=$(INC_HOME) $<

slicgldSCcheck.o : slicgldSCcheck.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

install:
	scp slicgldSCcheck $(PROD_DIR)/.

clean:
	rm -rf *.o *.c slicgldSCcheck
