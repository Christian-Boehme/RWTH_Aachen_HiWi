#!/usr/bin/env python3

import os
import sys
import shutil
from core import Functions as f
from core import JournalDictionary as JD

# inputs
directory = sys.argv[1]     # 5_All_PDF_Files_AfterZotaroRenaming
src_path = sys.argv[2]     # 6_All_PDF_Files_RenamedPDFs

# get the journal dictionary
JAbbrev = JD.JournalDictionary()

# rename all pdf files to new scheme
f.rename_pdf_files(directory, src_path, JAbbrev, True)
