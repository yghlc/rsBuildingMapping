#!/usr/bin/env bash

# exe in ~/experiment/caffe_deeplab on ee server
dir=~/experiment/caffe_deeplab
#city=spacenet_rgb_aoi_4_test
city=$1
echo $dir
echo $city
gpuid=6

# prepare list
cp -r cp_exper/${city} .
cd ${city}/list
cp ${dir}/spacenet_rgb_aoi_2-4/list/replace_wrong_path.py .

cat train_aug.txt test_aug.txt > train_aug_all.txt
cp train_aug_all.txt train_aug.txt
python replace_wrong_path.py train_aug.txt
python replace_wrong_path.py val.txt
cd ..

#prepare model
mkdir model
mkdir model/deeplab_largeFOV
cp ${dir}/spacenet_rgb_aoi_2-4/model/deeplab_largeFOV/train_iter_48000.caffemodel model/deeplab_largeFOV/init.caffemodel

#prepare config
cp -r ~/experiment/caffe_deeplab/spacenet_rgb_aoi_2-4/config .

cd ~/codes/rsBuildingSeg
git pull
cd -

# run fine train with deeplab
cp ~/codes/rsBuildingSeg/DeepLab-Context/run_train.py .
python run_train.py ${dir}/${city}  ${gpuid}

# produce the edge map of Test public data
#mkdir edge
#cd edge
#cp ~/codes/rcf/examples/rcf_building_edge/edge.sh .
#./edge.sh ../list/val.txt ${gpuid}
#cd ..

# run test on Test public data
cp ~/codes/rsBuildingSeg/DeepLab-Context/run_test_and_evaluate.py .
python run_test_and_evaluate.py ${dir}/${city}  ${gpuid}
cd ..

#cp csv
cp ${dir}/${city}/features/deeplab_largeFOV/val/fc8/result_buildings.csv result_csv/result_${city}.csv