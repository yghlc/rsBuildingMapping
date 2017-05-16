#!/usr/bin/env python
# Filename: test_readRSimg 
"""
introduction:

authors: Huang Lingcao
email:huanglingcao@gmail.com
add time: 16 May, 2017
"""

from optparse import OptionParser
import os
import basic.io_function as io_function

import scipy.io as sio
import scipy.misc as misc
import numpy
from PIL import Image

import matplotlib.pyplot as plt
from basic.RSImage import RSImageclass
from basic.RSImageProcess import RSImgProclass


def read_disp_img(img_path):
    if io_function.is_file_exist(img_path) is False:
        return False
    img_obj = RSImageclass()
    if img_obj.open(img_path) is False:
        return False

    band_count = img_obj.GetBandCount()
    width = img_obj.GetWidth()
    height = img_obj.GetHeight()

    # images = numpy.zeros((width, height, band_count, 1))

    img_pro = RSImgProclass()
    # img_pro.Read_Image_band_data_to_numpy_array_all_pixel(1,img_path)
    # for i in range(0,band_count):
    #     bandindex = i+1
    #     print(bandindex)
    #     band_img = img_pro.Read_Image_band_data_to_numpy_array_all_pixel(bandindex, img_path)
    #     band_img_float = band_img.astype(float)
    #     images[:,:,i,0] = band_img_float

    images = img_pro.Read_Image_data_to_numpy_array_all_band_pixel(img_path)
    if images is False:
        return False

    # print(images)

    # for display



    data = numpy.zeros((height, width, 3), dtype=numpy.uint8)
    disp_bands = [0,1,2]
    for i in range(0,3):
        image_band = images[:,:,disp_bands[i]]
        max_value = image_band.max()#numpy.max(image_band)
        min_value = image_band.min()
        data[:,:,i] = 255*(image_band - min_value)/(max_value - min_value)

    img = Image.fromarray(data, 'RGB')
    # img.save('my.png')
    img.show()


    # if args['--visualize']:
    #     plt.subplot(3, 1, 1)
    #     plt.imshow(img_original)
    #     plt.subplot(3, 1, 2)
    #     plt.imshow(gt)
    #     plt.subplot(3, 1, 3)
    #     plt.imshow(output)
    #     plt.show()


def main(options, args):
    tif_path = args[0]
    read_disp_img(tif_path)
    pass


if __name__=='__main__':
    usage = "usage: %prog [options] rsImg.tif"
    parser = OptionParser(usage=usage, version="1.0 2017-5-16")

    (options, args) = parser.parse_args()
    main(options, args)
