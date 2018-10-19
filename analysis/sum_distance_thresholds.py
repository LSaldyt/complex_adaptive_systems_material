#!/usr/bin/env python3
import os, sys
from functools import partial

import pickle
import pandas
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np

from collections import defaultdict

def main(args):
    filename = args[0]
    outfilename = args[1]
    threshold = args[2]
    with open(filename, 'r') as infile:
        lines = infile.read().split('\n')
    with open(outfilename, 'w') as outfile:
        first = lines[0]
        
        outfile.write(first + ', count_{}\n'.format(threshold))

        for line in lines[1:]:
            counter = 0
            for key, value in zip(first.split(','), line.split(',')):
                if key.strip().startswith('d') and \
                        float(value.strip()) < threshold:
                    counter += 1
            outfile.write(line + ', ' + str(counter) + '\n')
    return 0

if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
