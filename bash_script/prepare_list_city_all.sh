#!/usr/bin/env bash

# run in ~/experiment/caffe_deeplab/
dir=~/experiment/caffe_deeplab
dir_MUL_Pan_8bit=~/Data/aws_SpaceNet/voc_format
dir_MUL_Pan_16bit=~/Data/spacenet
pre_trained=${dir}/spacenet_rgb_aoi_2-4/model/deeplab_largeFOV/train_iter_48000.caffemodel

# true when on server
is_server=true

upcodes.sh

AOI_2=2
AOI_3=3
AOI_4=4
AOI_5=5

 #${AOI_3} ${AOI_4} ${AOI_5}
 #${AOI_3}
for num in ${AOI_5} ${AOI_2}  ${AOI_4}
do
city=spacenet_rgb_aoi_${num}_test
echo "current city: " ${city}

# prepare list
cp -r cp_exper/${city} .
cd ${city}/list
cat train_aug.txt test_aug.txt > train_aug_all.txt
cp train_aug_all.txt train_aug.txt

if [ "$is_server" = false ] ; then
#change RGB-PanSharpen_8bit to MUL-PanSharpen_8bit in the list
find ${dir_MUL_Pan_8bit}/AOI_${num}_*_Train/MUL-PanSharpen_8bit/*.tif > trainimg_mul_pan_8bit.txt
find ${dir_MUL_Pan_8bit}/AOI_${num}_*_Test_public/MUL-PanSharpen_8bit/*.tif > valimg_mul_pan_8bit.txt
else
find ${dir_MUL_Pan_16bit}/AOI_${num}_*_Train/MUL-PanSharpen/*.tif > trainimg_mul_pan_8bit.txt
find ${dir_MUL_Pan_16bit}/AOI_${num}_*_Test_public/MUL-PanSharpen/*.tif > valimg_mul_pan_8bit.txt
fi

python ~/codes/rsBuildingMapping/basic/combine_IMGpath_and_Groundpath.py trainimg_mul_pan_8bit.txt train_aug.txt save_train.txt

mv train_aug.txt train_aug_old.txt
cp save_train.txt train_aug.txt
mv val.txt  val_old.txt
# valimg_mul_pan_8bit.txt don't have ground true
cp valimg_mul_pan_8bit.txt val.txt

bash ~/codes/rsBuildingMapping/bash_script/extract_fileid.sh val


if [ "$is_server" = true ] ; then
    echo 'Replace the file path, because the above codes get new path, so it only replace the path of ground true'
    python ~/codes/rsBuildingMapping/replace_wrong_path.py train_aug.txt
    python ~/codes/rsBuildingMapping/replace_wrong_path.py val.txt
fi

# calculate mean value
cat train_aug.txt val.txt > cal_mean.txt
python ~/codes/rsBuildingMapping/basic/calculate_meanvalue.py cal_mean.txt
cp mean_value.txt ../config/deeplab_largeFOV/.

cd ..

#prepare model
mkdir model
mkdir model/deeplab_largeFOV
cp ${pre_trained} model/deeplab_largeFOV/init.caffemodel

#prepare config
cp -r ${dir}/spacenet_rgb_aoi_2-4/config .

cd ..


done






