#!/usr/bin/env bash

dir=$PWD

cd ${dir}/building_spacenet_init_files/trained_model
cp ../../building_spacenet_yghlc/train_AOI_2_Vegas_Train/model/deeplab_largeFOV/train_iter_6000.caffemodel vegas_train_iter_6000.caffemodel
cp ../../building_spacenet_yghlc/train_AOI_3_Paris_Train/model/deeplab_largeFOV/train_iter_6000.caffemodel paris_train_iter_6000.caffemodel
cp ../../building_spacenet_yghlc/train_AOI_4_Shanghai_Train/model/deeplab_largeFOV/train_iter_6000.caffemodel shanghai_train_iter_6000.caffemodel
cp ../../building_spacenet_yghlc/train_AOI_5_Khartoum_Train/model/deeplab_largeFOV/train_iter_6000.caffemodel khartoum_train_iter_6000.caffemodel
cd -

