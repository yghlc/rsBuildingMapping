#!/usr/bin/env bash


cd codes/rsBuildingSeg

# return to the version before adding opencv 3 with GDAL support
git reset --hard 5fb23254997931105afe00d996f98da619d08152

cd DeepLab-Context 
# clean the previous building files
make clean

make all -j8
#make test -j8

cd $HOME
