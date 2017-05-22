#!/usr/bin/env bash

# run in ~/experiment/caffe_deeplab/
dir=~/experiment/caffe_deeplab
dir_MUL_Pan_8bit=~/Data/aws_SpaceNet/voc_format

# true when on server
is_server=false

upcodes.sh

AOI_2=2
AOI_3=3
AOI_4=4
AOI_5=5

 #${AOI_3} ${AOI_4} ${AOI_5}
for num in ${AOI_2}
do
city=spacenet_rgb_aoi_${num}_test
echo "current city: " ${city}

# prepare list
cp -r cp_exper/${city} .
cd ${city}/list
cp ${dir}/spacenet_rgb_aoi_2-4/list/replace_wrong_path.py .
cat train_aug.txt test_aug.txt > train_aug_all.txt
cp train_aug_all.txt train_aug.txt



#change RGB-PanSharpen_8bit to MUL-PanSharpen_8bit in the list
# train images
find ${dir_MUL_Pan_8bit}/AOI_${num}_*_Train/MUL-PanSharpen_8bit/*.tif > trainimg_mul_pan_8bit.txt
find ${dir_MUL_Pan_8bit}/AOI_${num}_*_Test_public/MUL-PanSharpen_8bit/*.tif > valimg_mul_pan_8bit.txt

python ~/codes/rsBuildingMapping/basic/combine_IMGpath_and_Groundpath.py trainimg_mul_pan_8bit.txt train_aug.txt save_train.txt

mv train_aug.txt train_aug_old.txt
cp save_train.txt train_aug.txt
mv val.txt  val_old.txt
# valimg_mul_pan_8bit.txt don't have ground true
cp valimg_mul_pan_8bit.txt val.txt

bash ~/codes/rsBuildingMapping/bash_script/extract_fileid.sh val


if [ "$is_server" = true ] ; then
    echo 'Replace the file path, because the above codes get new path, so it only replace the path of ground true'
    python replace_wrong_path.py train_aug.txt
    python replace_wrong_path.py val.txt
fi

# calculate mean value
cat train_aug.txt val.txt > cal_mean.txt
python ~/codes/rsBuildingMapping/basic/calculate_meanvalue.py cal_mean.txt
cp mean_value.txt ../config/deeplab_largeFOV/.

cd ../..



done






