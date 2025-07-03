#!/usr/bin/env python3

import os
import sys
from core import Functions as func
from core import JournalDictionary as JD

# inputs
filename = sys.argv[1]
RenamedPDFs = sys.argv[2]

# output
outfile = filename[:-4] + '_Modified.bib'

# get all literature/pdf files in 04_sorted
RefFiles = [f for f in os.listdir(
    RenamedPDFs) if os.path.isfile(os.path.join(RenamedPDFs, f))]

# get journal dictionary
JAbbrev = JD.JournalDictionary()

# read data
data = func.read_file(filename)

# write bibliography
func.RenameFilenameInBibliography(outfile, data, RefFiles, JAbbrev)
