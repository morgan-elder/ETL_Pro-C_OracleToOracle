CC=gcc
DEBUG=
PROCOPT=
APP_HOME=${HOME}/src
INC_HOME=$(APP_HOME)/includes
CLNTSH=${ORACLE_HOME}/lib/libclntsh.so
PROD_DIR=nwlsap06.cs.boeing.com:/data/scm/c/exe
EXE_DIR=$(APP_HOME)/exe
PRECOMPINC=${ORACLE_HOME}/precomp/public/

# the .o file, which is $<, must precede all the -L libraries and -l archive
# or the linker won't find all the exteranl references to be resolved
slicgldCAT1 : slicgldCAT1.o 
	gcc -o $(EXE_DIR)/$@ $(CLNTSH) $< -L${ORACLE_HOME}/lib -L$(APP_HOME)/libs -lscm

slicgldCAT1.c : slicgldCAT1.pc $(INC_HOME)/gold685_cat1_api.h  $(INC_HOME)/GetTime.h
	proc $(PROCOPT) include=$(INC_HOME) $<

slicgldCAT1.o : slicgldCAT1.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

install:
	scp $(EXE_DIR)/slicgldCAT1 $(PROD_DIR)/.

clean:
	rm -rf *.o *.c $(EXE_DIR)/slicgldCAT1
