#!/bin/tcsh -f

source $MODULESHOME/init/csh

cd ../SHiELD_SRC/
echo `pwd`

git clone -b wave https://github.com/Biao-Zhao/MOM6.git
git clone -b wave https://github.com/Biao-Zhao/SIS2/
git clone  https://github.com/Biao-Zhao/icebergs/

(cd MOM6; git submodule update --recursive --init)
(cd SIS2; git submodule update --recursive --init)
