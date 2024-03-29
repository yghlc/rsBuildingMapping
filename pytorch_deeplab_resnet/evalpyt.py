import scipy
from scipy import ndimage
import cv2
import numpy as np
import sys
#sys.path.insert(0,'/data1/ravikiran/SketchObjPartSegmentation/src/caffe-switch/caffe/python')
#import caffe
import torch
from torch.autograd import Variable
import torchvision.models as models
import torch.nn.functional as F
import deeplab_resnet 
from collections import OrderedDict
import os
from os import walk
import matplotlib.pyplot as plt
import torch.nn as nn

import scipy.misc as misc


from docopt import docopt

# sys.path.insert(0,'/home/lchuang/codes/rsBuildingMapping')
import basic.io_function as io_function
import basic.basic as basic

docstr = """Evaluate ResNet-DeepLab with 5 branches on sketches of 11 categories (5 super categories)

Usage: 
    eval_r5.py [options]

Options:
    -h, --help                  Print this message
    --visualize                 view outputs of each sketch
    --LISTpath=<str>            Input image number list file [default: test_aug.txt]
    --snapPrefix=<str>          Snapshot [default: VOC12_scenes_]
    --testGTpath=<str>          Ground truth path prefix [default: data/gt/]
    --testIMpath=<str>          Sketch images path prefix [default: data/img/]
    --saveDir=<str>             Folder path for saving predict segmentation in PNG file
    --gpu0=<int>                GPU number [default: 0]
"""



def get_iou(pred,gt):
    if pred.shape!= gt.shape:
        print ('pred shape',pred.shape, 'gt shape', gt.shape)
    assert(pred.shape == gt.shape)    
    gt = gt.astype(np.float32)
    pred = pred.astype(np.float32)

    max_label = 20  # labels from 0,1, ... 20 
    count = np.zeros((max_label+1,))
    for j in range(max_label+1):
        x = np.where(pred==j)
        p_idx_j = set(zip(x[0].tolist(),x[1].tolist()))
        x = np.where(gt==j)
        GT_idx_j = set(zip(x[0].tolist(),x[1].tolist()))
        #pdb.set_trace()     
        n_jj = set.intersection(p_idx_j,GT_idx_j)
        u_jj = set.union(p_idx_j,GT_idx_j)
    
        
        if len(GT_idx_j)!=0:
            count[j] = float(len(n_jj))/float(len(u_jj))

    result_class = count
    Aiou = np.sum(result_class[:])/float(len(np.unique(gt))) 
    
    return Aiou

def read_file(path_to_file):
    with open(path_to_file) as f:
        img_list = []
        for line in f:
            img_list.append(line[:-1])
    return img_list


def run_evalpyt(gpu0,model_path,test_data,save_dir):

    model = getattr(deeplab_resnet, 'Res_Deeplab')()
    model.eval()
    model.cuda(gpu0)

    img_rows = 650
    img_cols = 650
    band = 3

    # model_path = os.path.join('data/snapshots/', snapPrefix + str(iter) + '000.pth')
    basic.outputlogMessage('the trained model file used in this test is: %s'%model_path)
    saved_state_dict = torch.load(model_path)

    model.load_state_dict(saved_state_dict)

    save_png_dir = save_dir
    if os.path.isdir(save_png_dir) is False:
        io_function.mkdir(save_png_dir)

    pytorch_list = []
    result_list = []
    count = 0
    for test_sample in test_data:
        img = np.zeros((663,663, band))
        count = count +1

        img_path = test_sample.image
        # img_temp = cv2.imread(os.path.join(im_path,i[:-1]+'.jpg')).astype(float)
        img_temp = cv2.imread(img_path).astype(float)
        img_original = img_temp
        img_temp[:, :, 0] = img_temp[:, :, 0] - 104.008
        img_temp[:, :, 1] = img_temp[:, :, 1] - 116.669
        img_temp[:, :, 2] = img_temp[:, :, 2] - 122.675
        img[:img_temp.shape[0], :img_temp.shape[1], :] = img_temp
        # gt = cv2.imread(os.path.join(gt_path,i[:-1]+'.png'),0)

        output = model(
            Variable(torch.from_numpy(img[np.newaxis, :].transpose(0, 3, 1, 2)).float(), volatile=True).cuda(gpu0))
        interp = nn.UpsamplingBilinear2d(size=(663, 663))
        output = interp(output[3]).cpu().data[0].numpy()
        output = output[:, :img_temp.shape[0], :img_temp.shape[1]]

        output = output.transpose(1, 2, 0)
        output = np.argmax(output, axis=2)

        # save to png
        result = np.uint8(output)
        result = result.reshape(img_rows, img_cols)
        result[np.where(result == 1)] = 255
        save_png = os.path.join(save_png_dir, test_sample.id +'.png')
        misc.imsave(save_png, result)
        result_list.append(save_png)
        basic.outputlogMessage('%d/%d : saved %s'%(count,len(test_data),save_png))

        # if args['--visualize']:
        #     plt.subplot(3, 1, 1)
        #     plt.imshow(img_original)
        #     plt.subplot(3, 1, 2)
        #     plt.imshow(gt)
        #     plt.subplot(3, 1, 3)
        #     plt.imshow(output)
        #     plt.show()

        png_path = test_sample.groudT
        if len(png_path)>0:
            gt = cv2.imread(png_path, 0)
            gt[gt == 255] = 0
            iou_pytorch = get_iou(output, gt)
            pytorch_list.append(iou_pytorch)

    if len(pytorch_list) > 0:
        print ('pytorch', iter, np.sum(np.asarray(pytorch_list)) / len(pytorch_list))
        basic.outputlogMessage('pytorch {} , {} \n'.format(iter, np.sum(np.asarray(pytorch_list)) / len(pytorch_list)))

    return result_list



if __name__ == '__main__':

    # args = docopt(docstr, version='v0.1')
    # print(args)
    #
    # gpu0 = int(args['--gpu0'])
    # im_path = args['--testIMpath']
    # model = getattr(deeplab_resnet, 'Res_Deeplab')()
    # model.eval()
    # counter = 0
    # model.cuda(gpu0)
    # snapPrefix = args['--snapPrefix']
    # gt_path = args['--testGTpath']
    # # img_list = open('data/list/val.txt').readlines()
    # img_list = read_file(args['--LISTpath'])
    #
    # for iter in range(1,11):  # TODO set the (different iteration)models that you want to evaluate on. Models are saved during training after each 1000 iters by default.
    #     saved_state_dict = torch.load(os.path.join('data/snapshots/', snapPrefix + str(iter) + '000.pth'))
    #     # saved_state_dict = torch.load(os.path.join('data/snapshots/', 'MS_DeepLab_resnet_trained_VOC.pth'))
    #     if counter == 0:
    #         print (snapPrefix)
    #     counter += 1
    #     model.load_state_dict(saved_state_dict)
    #
    #     save_png_dir = os.path.join('data', 'results', str(iter))
    #     io_function.mkdir(save_png_dir)
    #
    #     pytorch_list = [];
    #     for i in img_list:
    #         img = np.zeros((663, 663, 3));
    #
    #         # img_temp = cv2.imread(os.path.join(im_path,i[:-1]+'.jpg')).astype(float)
    #         img_temp = cv2.imread(os.path.join(im_path, i[:] + '.tif')).astype(float)
    #         img_original = img_temp
    #         img_temp[:, :, 0] = img_temp[:, :, 0] - 104.008
    #         img_temp[:, :, 1] = img_temp[:, :, 1] - 116.669
    #         img_temp[:, :, 2] = img_temp[:, :, 2] - 122.675
    #         img[:img_temp.shape[0], :img_temp.shape[1], :] = img_temp
    #         # gt = cv2.imread(os.path.join(gt_path,i[:-1]+'.png'),0)
    #         png_path = os.path.join(gt_path, i[:] + 'segcls.png')
    #         png_path = png_path.replace('_8bit', '')
    #         gt = cv2.imread(png_path, 0)
    #         gt[gt == 255] = 0
    #
    #         output = model(
    #             Variable(torch.from_numpy(img[np.newaxis, :].transpose(0, 3, 1, 2)).float(), volatile=True).cuda(gpu0))
    #         interp = nn.UpsamplingBilinear2d(size=(663, 663))
    #         output = interp(output[3]).cpu().data[0].numpy()
    #         output = output[:, :img_temp.shape[0], :img_temp.shape[1]]
    #
    #         output = output.transpose(1, 2, 0)
    #         output = np.argmax(output, axis=2)
    #
    #         # save to png
    #         result = np.uint8(output)
    #         result = result.reshape(650, 650)
    #         result[np.where(result == 1)] = 255
    #         save_png = os.path.join('data', 'results', str(iter), i + '.png')
    #         misc.imsave(save_png, result)
    #
    #         if args['--visualize']:
    #             plt.subplot(3, 1, 1)
    #             plt.imshow(img_original)
    #             plt.subplot(3, 1, 2)
    #             plt.imshow(gt)
    #             plt.subplot(3, 1, 3)
    #             plt.imshow(output)
    #             plt.show()
    #
    #         iou_pytorch = get_iou(output, gt)
    #         pytorch_list.append(iou_pytorch)
    #
    #     print ('pytorch', iter, np.sum(np.asarray(pytorch_list)) / len(pytorch_list))
    pass
