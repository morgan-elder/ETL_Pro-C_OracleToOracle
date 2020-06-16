CC=gcc
DEBUG=
PROCOPT=
SCM_HOME=${HOME}/src
INC_HOME=$(SCM_HOME)/includes
CLNTSH=${ORACLE_HOME}/lib/libclntsh.so
PROD_DIR=nwlsap06.cs.boeing.com:/data/scm/c/exe
EXE_DIR=$(SCM_HOME)/exe
PRECOMPINC=${ORACLE_HOME}/precomp/public/

slicgldVENN : slicgldVENN.o 
	gcc -o $@ $(CLNTSH) $@.o -L$(ORACLE_HOME)/lib -L$(SCM_HOME)/libs -lscm
	cp $@ $(EXE_DIR)/$@

slicgldVENN.c : slicgldVENN.pc $(INC_HOME)/gold685_cat1_api.h  $(INC_HOME)/GetTime.h
	proc $(PROCOPT) include=$(INC_HOME) $<

slicgldVENN.o : slicgldVENN.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

install:
	scp slicgldVENN $(PROD_DIR)/.

clean:
	rm -rf *.o *.c slicgldVENN
