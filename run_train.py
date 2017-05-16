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
HOME = os.path.expanduser('~')
codes_path = HOME +'/codes/rsBuildingMapping'
sys.path.insert(0, codes_path)

# modify this if necessary
expr_folder= HOME + '/experiment/pytorch_deeplab_resnet/spacenet_rgb_aoi_4'
train_list_file = 'trainval_aug.txt'
GTpath=HOME+'/Data/spacenet/voc_format/AOI_4_Shanghai_Train/annotations'
IMpath=HOME+'/Data/spacenet/voc_format/AOI_4_Shanghai_Train/annotations'
gpuid = 7



import basic.io_function as io_function
import basic.basic as basic
import basic.calculate_meanvalue as calculate_meanvalue
from basic.RSImage import RSImageclass
from basic.RSImageProcess import RSImgProclass

import pytorch_deeplab_resnet.train as train

if os.path.isdir(expr_folder) is False:
    print 'error, %s not exist '%expr_folder
    exit(1)

#TRAIN = 1
train_file = os.path.join(expr_folder,train_list_file)
# test_file = os.path.join(expr,'list/test_aug.txt')

class SampleClass(object):
    image = ''      # path of image
    groudT = ''     # path of groud image
    id = ''         # file ID
# list of SampleClass
train_data = []

def read_train_data(train_file,file_id=None):
    """
    read the file list
    :param test_file: file tontains the test file list
    :param file_id: id is need in caffe for output result, not need in pytorch_deeplab_resnet
    :return: True if succeful, False otherwise
    """
    if os.path.isfile(train_file) is False:
        basic.outputlogMessage('error: file not exist %s'%train_file)
        return False
    f_obj = open(train_file)
    f_lines = f_obj.readlines()
    f_obj.close()

    if file_id is not None:
        fid_obj = open(file_id)
        fid_lines = fid_obj.readlines()
        fid_obj.close()

        if len(f_lines) != len(fid_lines):
            basic.outputlogMessage('the number of lines in test_file and test_file_id is not the same')
            return False

        for i in range(0,len(f_lines)):
            temp = f_lines[i].split()
            sample = SampleClass()
            sample.image = temp[0]
            if len(temp) > 1:
                sample.groudT = temp[1]
            sample.id = fid_lines[i].strip()
            train_data.append(sample)
    else:
        for i in range(0, len(f_lines)):
            temp = f_lines[i].split()
            sample = SampleClass()
            sample.image = temp[0]
            if len(temp) > 1:
                sample.groudT = temp[1]
                train_data.append(sample)

    # prepare file for pytorch_deeplab_resnet
    if len(train_data)< 1:
        basic.outputlogMessage('error, not input test data ')
        return False

    # check all image file and ground true file
    for sample in train_data:
        # check image path
        image_basename = os.path.basename(sample.image)
        if os.path.isfile(sample.image) is False:
            # sample.image = os.path.basename(sample.image)
            sample.image =os.path.join(IMpath,image_basename)
        if os.path.isfile(sample.image) is False:
            basic.outputlogMessage('error, file not exist: %s'%sample.image)
            return False

        # check ground path
        if len(sample.groudT)>0 and os.path.isfile(sample.groudT) is False:
            sample.groudT = os.path.basename(sample.groudT)
            sample.groudT = os.path.join(GTpath, sample.groudT)

        if len(sample.id)< 1:
            sample.id = os.path.splitext(image_basename)[0]

    basic.outputlogMessage('read test data completed, sample count %d'%len(test_data))
    return True

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

    if len(train_data)<1:
        basic.outputlogMessage('error, No input image for training')
        return False

    init_model_path ='data/MS_DeepLab_resnet_pretrained_COCO_init.pth'
    train.run_training(gpuid,init_model_path,train_data)

    pass


def main():

    if read_train_data(train_file) is False:
        return False


    # need to run and set the mean value manully at first time
    # cal_mean_value_of_each_band(train_file,test_file)

    # make sure alreay prepare the init model, set iteration number .... manully
    run_train()


    pass

if __name__=='__main__':
    main()