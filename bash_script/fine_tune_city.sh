#!/usr/bin/env bash

# exe in ~/experiment/caffe_deeplab on ee server
dir=~/experiment/caffe_deeplab
#city=spacenet_rgb_aoi_4_test
city=$1
echo $dir
echo $city
gpuid=6


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