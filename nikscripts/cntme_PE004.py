#!/usr/bin/python

import os
import fnmatch
import numpy as np

def main():

    seeds_path="/working/lab_michaebr/nikitasK/epilepsy/old_subjects/PE004_seeds.txt"
    AFD_path="/working/lab_michaebr/nikitasK/epilepsy/old_subjects/AFD/electrodetracking/PE004/"
    array=np.empty([len(open(seeds_path).readlines()), len(open(seeds_path).readlines())])

    for i in range(0,len(open(seeds_path).readlines())):
               
      for j in range(0,len(open(seeds_path).readlines())):

        seed = open(seeds_path,'r').readlines()[i]
        seed = seed.replace("\n","")
        target = open(seeds_path,'r').readlines()[j]
        target = target.replace("\n","")
        pattern = seed + '_to_' + target + '_AFD.txt'
    
        if j > i:
          for dirpath, dirnames, files in os.walk(AFD_path):
              for name in fnmatch.filter(files, pattern):
                  fp = AFD_path + name
                  array[i,j] = open(fp,'r').read()
        else:
          array[i,j] = 0

    file = open(PE004_cntme.txt,'w')
    file.write(array)
    file.close()

if __name__ == "__main__":
    print("Processing subject AFD connectome from files. This may take a long time...")
    main()
