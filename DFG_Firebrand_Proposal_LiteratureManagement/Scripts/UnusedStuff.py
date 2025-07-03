#!/usr/bin/env python3

import os
import sys
from core import Functions as func
from core import JournalDictionary as JD

# inputs
pdf_path = sys.argv[1]
bib = sys.argv[2]

# get all pdf's
PDFs = sorted([f for f in os.listdir(
    pdf_path) if os.path.isfile(os.path.join(pdf_path, f))])

# define output filename for modified bibliography
ofile = bib[:-4] + '_renamed.bib'

# get journal dictionary
JAbbrev = JD.JournalDictionary()

#
for f in PDFs:
    print(f)
    # returns a error message if the filename is not found
    f_bib = func.ExtractBibliography(f, bib)

# abbreviation -> Zotero filename
Bib = func.read_file(bib)
####func.RenameFilenameInBibliography(ofile, Bib, PDFs, JAbbrev)

