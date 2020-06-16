CC=gcc
DEBUG=
PROCOPT=
SCM_HOME=${HOME}/src
INC_HOME=$(SCM_HOME)/includes
CLNTSH=${ORACLE_HOME}/lib/libclntsh.so
PROD_DIR=nwlsap06.cs.boeing.com:/data/scm/c/exe
EXE_DIR=$(SCM_HOME)/exe
PRECOMPINC=${ORACLE_HOME}/precomp/public/
UID=stlscm/May092020prodsup01ShelterPlace@stl_prodsup01

gldCATAPIU : gldCATAPIU.o 
	gcc -o $(EXE_DIR)/$@ $< $(CLNTSH) -L$(ORACLE_HOME)/lib -L$(SCM_HOME)/libs -lscm 

gldCATAPIU.c : gldCATAPIU.pc 
	echo proc $(PROCOPT) SQLCHECK=SEMANTICS USERID=$(UID) include=$(INC_HOME) $<
	proc $(PROCOPT) SQLCHECK=SEMANTICS USERID=$(UID) include=$(INC_HOME) $<

gldCATAPIU.o : gldCATAPIU.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

install:
	scp gldCATAPIU $(PROD_DIR)/.

clean:
	rm -rf *.o *.c gldCATAPIU
