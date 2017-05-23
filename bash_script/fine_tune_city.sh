#!/usr/bin/env bash

# exe in ~/experiment/caffe_deeplab on ee server
dir=~/experiment/caffe_deeplab
deeplab=~/codes/rsBuildingSeg/DeepLab-Context
net=deeplab_largeFOV
#city=spacenet_rgb_aoi_4_test
bresuming=true
btraining=true
btesting=true
city=$1
echo $dir
echo $city
gpuid=$2


cd ~/codes/rsBuildingSeg
git pull
cd -

cd ${dir}/${city}

if [ "$btraining" = true ] ; then

if [ "$bresuming" = false ] ; then
# run fine train with deeplab
python ${deeplab}/run_train.py ${dir}/${city}  ${gpuid}
else
# get latest solverstate file
newest_solverstate=$(ls -t ${dir}/${city}/model/${net}/*.solverstate | head -1)
echo "resuming with:" ${newest_solverstate}
${deeplab}/.build_release/tools/caffe.bin  train --solver=${dir}/${city}/config/${net}/solver_train_aug.prototxt --snapshot=${newest_solverstate} -gpu ${gpuid}
fi

fi

# produce the edge map of Test public data
#mkdir edge
#cd edge
#cp ~/codes/rcf/examples/rcf_building_edge/edge.sh .
#./edge.sh ../list/val.txt ${gpuid}
#cd ..

if [ "$btesting" = true ] ; then
# clean previous result
rm ${dir}/${city}/features/${net}/val/fc8/*.mat
rm ${dir}/${city}/features/${net}/val/fc8/*.png
rm -r ${dir}/${city}/features/${net}/val/fc8/geojson
rm -r ${dir}/${city}/features/${net}/val/fc8/geojson_without_fix
rm ${dir}/${city}/features/${net}/val/fc8/result_buildings.csv
# run test on Test public data
python ~/codes/rsBuildingSeg/DeepLab-Context/run_test_and_evaluate.py ${dir}/${city}  ${gpuid}
fi

cd ..

#cp csv
cp ${dir}/${city}/features/${net}/val/fc8/result_buildings.csv result_csv/result_${city}.csv