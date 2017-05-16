#!/usr/bin/env python
# Filename: run_train.py
"""
introduction: run the train by using run_deeplab.py

authors: Huang Lingcao
email:huanglingcao@gmail.com
add time: 23 April, 2017
"""

import os,sys
# modify this if necessary
codes_path = '/home/lchuang/codes/rsBuildingMapping'
sys.path.insert(0, codes_path)

# modify this if necessary
expr_folder='/home/lchuang/experiment/pytorch_deeplab_resnet/spacenet_rgb_aoi_4'
train_list_file = 'trainval_aug.txt'
GTpath='/home/lchuang/Data/spacenet/voc_format/AOI_4_Shanghai_Train/annotations'
IMpath='/home/lchuang/Data/spacenet/voc_format/AOI_4_Shanghai_Train/annotations'
gpuid = 7


import basic.io_function as io_function
import basic.calculate_meanvalue as calculate_meanvalue
from basic.RSImage import RSImageclass
from basic.RSImageProcess import RSImgProclass


if os.path.isdir(expr_folder) is False:
    print 'error, % not exist '%expr_folder
    exit(1)

#TRAIN = 1
train_file = os.path.join(expr_folder,'train_list_file')
# test_file = os.path.join(expr,'list/test_aug.txt')

class SampleClass(object):
    image = ''      # path of image
    groudT = ''     # path of groud image
    id = ''         # file ID
# list of SampleClass
test_data = []

def cal_mean_value_of_each_band(train_file,test_file):

    if io_function.is_file_exist(train_file) is False or io_function.is_file_exist(test_file) is False:
        return False

    whole_data_set = []
    f_obj = open(train_file,'r')
    for line in f_obj.readlines():
        img_path = line.split()[0]
        whole_data_set.append(img_path)
    f_obj.close()

    f_obj = open(test_file,'r')
    for line in f_obj.readlines():
        img_path = line.split()[0]
        whole_data_set.append(img_path)
    f_obj.close()

    # for i in range(0,len(f_lines)):
    #     temp = f_lines[i].split()
    #     # temp[1].
    #     temp.append(fid_lines[i].strip())
    #     test_data.append(temp)

    mean_of_images = calculate_meanvalue.calculate_mean_of_images(whole_data_set)

    # write means to train_prototxt_tem and test_prototxt_tem
    # set it manually
    f_obj =  open('mean_value.txt','w')
    for i in range(0,len(mean_of_images)):
        f_obj.writelines('band {}: mean {} \n'.format(i+1,mean_of_images[i]))
    f_obj.close()

    return True


def run_train():
    # train 1


    pass


def main():

    # need to run and set the mean value manully at first time
    # cal_mean_value_of_each_band(train_file,test_file)

    # make sure alreay prepare the init model, set iteration number .... manully
    run_train()


    pass

if __name__=='__main__':
    main()