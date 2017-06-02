#!/usr/bin/env bash


cd codes/rsBuildingSeg

# return to the version before adding opencv 3 with GDAL support
git reset --hard 5fb23254997931105afe00d996f98da619d08152

# return to the version for deep learning course project (April 23, 2017)
#git reset --hard 3058d35197bf46f0f1350cb0c9598c43a35e85ea

cd DeepLab-Context 
# clean the previous building files
make clean

make all -j8
#make test -j8

# after building, get the newest python script
git pull

cd $HOME
