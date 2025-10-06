#!/bin/tcsh -f

source $MODULESHOME/init/csh

cd ../SHiELD_SRC/
echo `pwd`

git clone -b shield_mom_ww3_coupling https://github.com/Biao-Zhao/WW3.git
