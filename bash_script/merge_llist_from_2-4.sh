#!/usr/bin/env bash

# run in the spacenet_rgb_aoi_2-4/list

cp ../../spacenet_rgb_aoi_2/list/train_aug.txt  train_aug_2.txt
cp ../../spacenet_rgb_aoi_3/list/train_aug.txt  train_aug_3.txt
cp ../../spacenet_rgb_aoi_4/list/train_aug.txt  train_aug_4.txt
cp ../../spacenet_rgb_aoi_5/list/train_aug.txt  train_aug_5.txt

cp ../../spacenet_rgb_aoi_2/list/test_aug.txt  test_aug_2.txt
cp ../../spacenet_rgb_aoi_3/list/test_aug.txt  test_aug_3.txt
cp ../../spacenet_rgb_aoi_4/list/test_aug.txt  test_aug_4.txt
cp ../../spacenet_rgb_aoi_5/list/test_aug.txt  test_aug_5.txt

cat train_aug_2.txt train_aug_3.txt train_aug_3.txt train_aug_4.txt > train_aug.txt
cat test_aug_2.txt  test_aug_3.txt test_aug_4.txt test_aug_5.txt > test_aug.txt

cat train_aug.txt test_aug.txt > train_aug_all.txt





