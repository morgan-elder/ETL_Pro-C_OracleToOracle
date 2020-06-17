CC=gcc
DEBUG=
PROCOPT=
APP_HOME=${HOME}/src
INC_HOME=$(APP_HOME)/includes
CLNTSH=${ORACLE_HOME}/lib/libclntsh.so
PROD_DIR=nwlsap06.cs.boeing.com:/data/scm/c/exe
EXE_DIR=$(APP_HOME)/exe
PRECOMPINC=${ORACLE_HOME}/precomp/public/

libscm.a: db_err.o BinTree.o addSecondToDate.o \
  GetTime.o leftstr.o Login.o \
  midstr.o nsn_niin_conv.o OpenFile.o \
  rightstr.o SetBasicPart.o StripCommas.o \
  strng2int.o str_procs.o substr.o \
  check_STL_Part.o rpad.o varcharSetup.o 
	ar -r $@ $?

db_err.c : db_err.pc 
	proc $(PROCOPT) include=$(INC_HOME) $<

db_err.o : db_err.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

BinTree.o : BinTree.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

addSecondToDate.c : addSecondToDate.pc 
	proc $(PROCOPT) include=$(INC_HOME) $<

addSecondToDate.o : addSecondToDate.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

GetTime.o : GetTime.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

leftstr.o : leftstr.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

Login.c : Login.pc 
	proc $(PROCOPT) include=$(INC_HOME) $<

Login.o : Login.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

midstr.o : midstr.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

nsn_niin_conv.o : nsn_niin_conv.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

OpenFile.c : OpenFile.pc 
	proc $(PROCOPT) include=$(INC_HOME) $<

OpenFile.o : OpenFile.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

rightstr.o : rightstr.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

SetBasicPart.c : SetBasicPart.pc 
	proc $(PROCOPT) include=$(INC_HOME) $<

SetBasicPart.o : SetBasicPart.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

StripCommas.o : StripCommas.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

strng2int.o : strng2int.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

str_procs.o : str_procs.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

substr.o : substr.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

check_STL_Part.o : check_STL_Part.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

rpad.o : rpad.c
	$(CC) $(DEBUG) -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

varcharSetup.o : varcharSetup.c
	$(CC) $(DEBUG) -o $@ -O -c -I $(PRECOMPINC) -I $(INC_HOME) $<

clean:
	rm -rf Login.c OpenFile.c SetBasicPart.c addSecondToDate.c db_err.c *.o 

install:
	cp libscm.a $(APP_HOME)/libs/. 
