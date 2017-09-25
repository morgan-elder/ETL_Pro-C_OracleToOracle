#!/bin/ksh
# vim: ff=unix
# compileSlicToGold.ksh
#


HOME=/net/psn02hom/home/z/zf297a
. $HOME/.profile

alias mycl="$HOME/bin/myCompileLink.ksh"
alias mycsub="$HOME/bin/myCompileLib.ksh"
alias execp="$HOME/bin/execp.ksh"

 current_time=$(date "+%Y_%m_%d_%H_%M_%S")

{
cd /mcair/dev/appl/scm/work/c

cd shared_routines
mycsub BinTree
mycsub GetTime
mycsub Login
mycsub OpenFile
mycsub SetBasicPart
mycsub StripCommas
mycsub addSecondToDate
mycsub check_STL_Part
mycsub db_err
mycsub getEnvVar
mycsub getMachineName
mycsub helloWorld
mycsub leftstr
mycsub listEnv
mycsub midstr
mycsub nsn_niin_conv
mycsub rightstr
mycsub rpad
mycsub str_procs
mycsub strng2int
mycsub substr
mycsub testGetMachineName
mycsub testGethostname
mycsub testInit
mycsub testRpad
mycsub testRtrim
mycsub testStrRight
mycsub testVarcharSetup
mycsub varcharSetup
cd ..

cd assignIMSDesC
mycl assignIMSDesC
execp assignIMSDesC
cd ..

cd gldCATAPIU
./compLink.ksh
rc=$?
if [ $rc -eq 0 ] ; then
  execp gldCATAPIU
fi
cd ..

cd gld_metric_load
mycl gld_metric_load
execp gld_metric_load
cd ..

cd parkerpbl
mycl parker
execp parker
cd ..

cd slicgldACTD
mycl slicgldACTD
execp slicgldACTD
cd ..

cd slicgldAddCat1
mycl slicgldAddCat1
execp slicgldAddCat1
cd ..

cd slicgldCAT1
mycl slicgldCAT1
execp slicgldCAT1
cd ..

cd slicgldFMT
mycl slicgldFMT
execp slicgldFMT
cd ..

cd slicgldHA
mycl slicgldHA
execp slicgldHA
cd ..

cd slicgldHAX04
mycl slicgldHAX04
execp slicgldHAX04
cd ..

cd slicgldHB
mycl slicgldHB
execp slicgldHB
cd ..

cd slicgldHG
mycl slicgldHG
execp slicgldHG
cd ..

cd slicgldHP
mycl slicgldHP
execp slicgldHP
cd ..

cd slicgldPRIME
mycl slicgldPRIME
execp slicgldPRIME
cd ..

cd slicgldSCcheck
mycl slicgldSCcheck
execp slicgldSCcheck
cd ..

cd slicgldVENN
mycl slicgldVENN
execp slicgldVENN
cd ..

cd slicgldVNDRcheck
mycl slicgldVNDRcheck
execp slicgldVNDRcheck
cd ..

cd sortAltPrimes
mycl sortAltPrimes
execp sortAltPrimes
cd ..

cd slicgldHAHBchk
mycl slicgldHAHBchk
execp slicgldHAHBchk
cd ..

cd slicgldPULL
mycl slicgldPULL
execp slicgldPULL
cd ..

cd ACDCBuildData
mycl ACDCBuildData
execp ACDCBuildData
cd ..

cd ACDCBuildDataM
mycl ACDCBuildDataM
execp ACDCBuildDataM
cd ..

} 2>&1 | tee -a /tmp/${current_time}_build.txt
