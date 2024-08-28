#!/usr/bin/env python

import sys

outfile = open(sys.argv[3], 'w')

hits_dict = {}
for i in open(sys.argv[1],'r'):
    x = i.strip().split('\t')
    hits_dict[x[0]] = x[1:len(x)]

#for key in hits_dict.keys():
 #   print(key, hits_dict[key])

## This is the silva taxononmy file that you are getting the taxonomic strings from
for line in open(sys.argv[2], 'r'):
    x = line.strip().split('\t')
    for key in hits_dict.keys():
        if hits_dict[key][0] == x[0]:
            outfile.write(key+'\t'+x[0]+'\t'+'\t'.join(x[1].split("|"))+'\n')
