#!/usr/bin/env python
import sys

outfile = open(sys.argv[2],'w')
dat = open(sys.argv[1], 'r')
for line in dat:
    x = line.strip().split('\t')
#    print(x[12])
    sample_count_list = []
    snum = 11
    for i in range(snum):

        for ele in range(int(x[i])):
            print(i,ele,x[12])
            outfile.write(">sample-"+str(i)+"_Read"+str(ele)+'\n'+x[12]+'\n')
