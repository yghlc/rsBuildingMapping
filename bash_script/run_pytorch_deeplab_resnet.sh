#!/usr/bin/env bash

#experid=


python /home/lchuang/codes/pytorch-deeplab-resnet/train.py --lr 0.00025 --wtDecay 0.0005 --gpu0 6 --maxIter 10000 --GTpath /home/lchuang/Data/spacenet/voc_format/AOI_4_Shanghai_Train/annotations --IMpath /home/lchuang/Data/spacenet/voc_format/AOI_4_Shanghai_Train/annotations --LISTpath trainval_aug.txt

#python /home/lchuang/codes/pytorch-deeplab-resnet/evalpyt.py --gpu0 7 --testGTpath /home/lchuang/Data/spacenet/voc_format/AOI_4_Shanghai_Train/annotations  --testIMpath /home/lchuang/Data/spacenet/voc_format/AOI_4_Shanghai_Train/annotations --snapPrefix spacenet_  --LISTpath test_aug.txt

python /home/lchuang/codes/rsBuildingMapping/pytorch-deeplab-resnet/evalpyt.py --gpu0 7 --testGTpath /home/lchuang/Data/spacenet/voc_format/AOI_4_Shanghai_Train/annotations  --testIMpath /home/lchuang/Data/spacenet/voc_format/AOI_4_Shanghai_Train/annotations --snapPrefix spacenet_  --LISTpath test_aug.txt