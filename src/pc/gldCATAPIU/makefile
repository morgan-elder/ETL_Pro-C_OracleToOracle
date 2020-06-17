CC=gcc
DEBUG=
PROCOPT=
APP_HOME=${HOME}/src
INC_HOME=$(APP_HOME)/includes
CLNTSH=${ORACLE_HOME}/lib/libclntsh.so
PROD_DIR=nwlsap06.cs.boeing.com:/data/scm/c/exe
EXE_DIR=$(APP_HOME)/exe
PRECOMPINC=${ORACLE_HOME}/precomp/public/
# the connection string must be in this format accout/password@db
UID=stlscm/May092020prodsup01ShelterPlace@stl_prodsup01

# $< (i.e. the gldCATAPIU.o file) must precede all -L's and -l's
# for the linker to work and resolve all external references used
# by the gldCATAPIU including the subroutines .o files
# in src/libs/libscm.a
gldCATAPIU : gldCATAPIU.o 
	$(CC) -o $(EXE_DIR)/$@ $< $(CLNTSH) -L${ORACLE_HOME}/lib \
		-L$(APP_HOME)/libs -lscm 

# Pro*C's proc needs to login to the db to valid the table structures
# to compile the .pc file and create a .c file
gldCATAPIU.c : gldCATAPIU.pc 
	proc $(PROCOPT) SQLCHECK=SEMANTICS USERID=$(UID) include=$(INC_HOME) $<

gldCATAPIU.o : gldCATAPIU.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

install:
	scp $(EXE_DIR)/gldCATAPIU $(PROD_DIR)/.

clean:
	rm -rf *.o *.c $(EXE_DIR)/gldCATAPIU
