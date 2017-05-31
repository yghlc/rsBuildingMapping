#!/usr/bin/env bash

dir=$PWD

net=deeplab_largeFOV

cd ${dir}/building_spacenet_init_files/trained_model
cp ../../building_spacenet_yghlc/train_AOI_2_Vegas_Train/model/${net}/train_iter_6000.caffemodel AOI_2_test/${net}/train_iter_6000.caffemodel
cp ../../building_spacenet_yghlc/train_AOI_3_Paris_Train/model/${net}/train_iter_6000.caffemodel AOI_3_test/${net}/train_iter_6000.caffemodel
cp ../../building_spacenet_yghlc/train_AOI_4_Shanghai_Train/model/${net}/train_iter_6000.caffemodel AOI_4_test/${net}/train_iter_6000.caffemodel
cp ../../building_spacenet_yghlc/train_AOI_5_Khartoum_Train/model/${net}/train_iter_6000.caffemodel AOI_5_test/${net}/train_iter_6000.caffemodel
cd -

