#!/usr/bin/env python
# Filename: replace_wrong_path 
"""
introduction:

authors: Huang Lingcao
email:huanglingcao@gmail.com
add time: 17 May, 2017
"""


import os,sys
from optparse import OptionParser

def main(options, args):
    file =args[0]
    f_obj = open(file,'r')
    fw_obj = open('temp.txt','w')
    for line in f_obj.readlines():
        line = line.replace('.jpg','.tif')
        line = line.replace('/home/hlc/Data/aws_SpaceNet/voc_format','/home/lchuang/Data/spacenet/voc_format')
        line = line.replace('/media/hlc/DATA/Data_lingcao/aws_SpaceNet/voc_format','/home/lchuang/Data/spacenet/voc_format')
        fw_obj.writelines(line)
    f_obj.close()

    os.system('cp '+file+' backup.txt ')
    os.system('mv '+' temp.txt ' + file)
    pass


if __name__=='__main__':
    usage = "usage: %prog [options] rsImg.tif"
    parser = OptionParser(usage=usage, version="1.0 2017-5-16")

    (options, args) = parser.parse_args()
    main(options, args)

