CC=gcc
DEBUG=
PROCOPT=
SCM_HOME=${HOME}/src
INC_HOME=$(SCM_HOME)/includes
CLNTSH=${ORACLE_HOME}/lib/libclntsh.so
PROD_DIR=nwlsap06.cs.boeing.com:/data/scm/c/exe
EXE_DIR=$(SCM_HOME)/exe
PRECOMPINC=${ORACLE_HOME}/precomp/public/

slicgldAddCat1 : slicgldAddCat1.o 
	gcc -o $@ $(CLNTSH) $@.o -L$(ORACLE_HOME)/lib -L$(SCM_HOME)/libs -lscm
	cp $@ $(EXE_DIR)/$@

slicgldAddCat1.c : slicgldAddCat1.pc $(INC_HOME)/gold685_cat1_api.h  $(INC_HOME)/GetTime.h
	proc $(PROCOPT) include=$(INC_HOME) $<

slicgldAddCat1.o : slicgldAddCat1.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

install:
	scp slicgldAddCat1 $(PROD_DIR)/.

clean:
	rm -rf *.o *.c slicgldAddCat1
