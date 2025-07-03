#!/usr/bin/env python3

import os
import sys
import shutil
from core import Functions as func


# input
src_path = sys.argv[1]
dest_path = sys.argv[2]
bib_file_global = sys.argv[3]
bib_file_local = sys.argv[4]

# create a backup of the 'global'-bibliography file
shutil.copy(bib_file_global, bib_file_global[:-4] + '_BU.bib')

# files in source directory
src_files = [f for f in os.listdir(
    src_path) if os.path.isfile(os.path.join(src_path, f))]

# files in destination directory ('merged' folder)
dest_files = [f for f in os.listdir(
    dest_path) if os.path.isfile(os.path.join(dest_path, f))]

for f in src_files:
    if f not in dest_files:
        print('Move file: ', f)
        shutil.copyfile(src_path + '/' + f, dest_path + '/' + f)
        func.AddBibliography([f], bib_file_local, bib_file_global)
    else:
        print('=> Duplicated file detected: ', f)
