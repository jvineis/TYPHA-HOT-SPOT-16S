#!/usr/bin/env python
import sys

outfile = open(sys.argv[2],'w')
dat = open(sys.argv[1], 'r')
sample_names = []
count = 0
sample_dict = {}
for i in open(sys.argv[3],'r'):
    x = i.strip()
    sample_dict[count] = x
    count += 1

for line in dat:
    x = line.strip().split('\t')
#    print(x[12])
    snum = 11
    for i in range(snum):
        for ele in range(int(x[i])):
#            print(i,ele,x[12])
            print(sample_dict[i])
            outfile.write(">"+sample_dict[i]+"_Read"+str(ele)+'\n'+x[12]+'\n')
