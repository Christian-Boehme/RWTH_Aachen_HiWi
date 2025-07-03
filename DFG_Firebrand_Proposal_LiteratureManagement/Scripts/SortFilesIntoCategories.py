#!/usr/bin/env python3

import re
import os
import sys
import pypdf
import shutil
import pdfplumber
from core import Functions as func


# inputs
filename = sys.argv[1]  # Proposal
PDFs_sorted = sys.argv[2]   # 04_sorted

# hardcoded references - reference overleaf: pdf-filename, internal
Bibliography = {'WFMMC. ON FIRE: The Report of the Wildland Fire Mitigation and Management Commission. Tech. rep. United States: Wildland Fire Mitigation and Management Commission, Sept. 2023, p. 329.': ['USDA_2023__Wildland_Fire_Mitigration_and_Management_Commission.pdf', False],
                'Johnston, L., Blanchi, R., and Jappiot, M. “Wildland-Urban Interface”. Encyclopedia of Wildfires and Wildland-Urban Interface (WUI) Fires. Ed. by Manzello, S. L. Cham: Springer Int. Publ., 2019, pp. 1–13. ISBN : 978-3-319-51727-8.': ['Springer_2020_Manzello_Encyclopedia_of_Wildfires_and_Wildland-Urban_Interface_(WUI)_Fires.pdf', False],
                'Manzello, S. L., Almand, K., Guillaume, E., Vallerent, S., Hameury, S., and Hakkarainen, T. “FORUM Position Paper: The Growing Global WUI Fire Dilemma: Priority Needs for Research”. Fire Safety J. 100 (2018), pp. 64–66.': ['FSJ_2018_Manzello_FORUM_Position_Paper_The_Growing_Global_Wildland_Urban_Interface_(WUI)_Fire_Dilemma_Priority_Needs_for_Research.pdf', False],
                #'Lelouvier, R., Nuijten, D., Onida, M., Stoof, C., et al. Land-based wildfire prevention: principles and experiences on managing landscapes, forests and woodlands for safety and resilience in Europe. Publications Office of the European Union, 2021.': ['EU_2021_Lelouvier_Land-based_wildfire_prevention.pdf', False],
                'Lelouvier, R., Nuijten, D., Onida, M., Stoof, C., et al. Land-based wildfire prevention: principles and experiences on managing landscapes, forests and woodlands for safety and resilience in Europe. Publ. Office of the EU, 2021.': ['EU_2021_Lelouvier_Land-based_wildfire_prevention.pdf', False],
                'Hedayati, F . and Quarles, S. L. The Ability of the Current ASTM Test Method to Evaluate the Performance of Deck Assemblies Under Realistic Wildfire Conditions. Tech. rep. Richburg, United States: Insurance Institute for Business & Home Safety, Oct. 2020, p. 18.': ['IBHS_2020_Hedayati_The_Ability_of_the_Current_ASTM_Test_Method_to_Evaluate_the_Performace_of_Deck_Assemnlies_Under_Realistic_Wildfire_Conditions.pdf', False],
                'overleaf': ['xyz.pdf', False]}  # extend if necessary ...

# symbols - ignore these to compare filenames
symbols = ['_', '-', '–', '‐', '/']

# get all literature/pdf files in 04_sorted
RefFiles = sorted([f for f in os.listdir(PDFs_sorted) if os.path.isfile(
    os.path.join(PDFs_sorted, f)) and f.endswith('.pdf')])

# get bib file
BibFile = [f for f in os.listdir(PDFs_sorted) if os.path.isfile(
    os.path.join(PDFs_sorted, f)) and f.endswith('.bib')]
if len(BibFile) != 1:
    sys.exit('\nDetected more than one .bib file in directory!')
BibFile = BibFile[0]

# read bibliography file (*.bib)
BibliographyFile = func.read_file(PDFs_sorted + '/' + BibFile)

# read pdf
reader = pypdf.PdfReader(filename)

# extract data
end = 0
start = 0
data = []
pages = len(reader.pages)
for page in range(pages):
    if 'Project- and subject-related list of publications' in reader.pages[page].extract_text():
        start = page
    elif 'Supplementary information on the research context' in reader.pages[page].extract_text():
        end = page
    data.append(reader.pages[page].extract_text())
data = data[start:end]

# page to lines
lines = []
for line in range(len(data)):
    lines.append(data[line].split('\n'))

# 2D list -> 1D list
lines = sum(lines, [])

# remove text on initial page
LiteratureStart = -1
for line in range(len(lines)):
    if lines[line].startswith('[E1] '):
        LiteratureStart = line
if LiteratureStart == -1:
    sys.exit('\nCould not find start of literature!')

# extract literature from pdf
Literature = lines[LiteratureStart:]

# one line = one bibliography element
Bib_OverLeaf = []
ele = Literature[0]
for line in Literature[1:]:
    if line.startswith('['):
        Bib_OverLeaf.append(ele)
        ele = line
    else:
        ele += ' ' + line
Bib_OverLeaf.append(ele)

# remove page title
header_string = ' DFG form ' # start of page-header
for i in range(len(Bib_OverLeaf)):
    if header_string in Bib_OverLeaf[i]:
        Bib_OverLeaf[i] = Bib_OverLeaf[i].split(header_string)[0]

# get respective pdf file to each literature element in proposal
Bib_OverLeaf = Bib_OverLeaf #[70:72]  # [7:27] #[:20]
counter = 0
ExternalPDFs = []
InternalPDFs = []
for ref in Bib_OverLeaf:
    found = False
    internal = False
    print('Reference: ', ref)
    author, title = func.ExtractInformationFromReference(ref)
    print('title:',  title)
    print('author: ', author)
    for i in RefFiles:
        if '_' + author + '_' in i:
            stitle = title.split(' ')
            mod_title = '_'.join(stitle)
            ref_title = i.split('_')[3:]
            ref_title = '_'.join(ref_title)[:-4]
            # ignore all '_' or '-' symbols in filename
            mod_title = func.ignore_symbols(mod_title, symbols)
            ref_title = func.ignore_symbols(ref_title, symbols)
            if mod_title == '':
                break
            print('Mod title: ', mod_title)
            print('Ref_title: ', ref_title)
            if mod_title.lower() in i.lower() or ref_title.lower() in mod_title.lower() or mod_title.lower() in ref_title.lower():
                pdf = i
                internal = func.CheckIfRefIsInternal(BibliographyFile, pdf)
                print('PDF file: ', i)
                # print('Mod title: ', mod_title)
                # print('Ref_title: ', ref_title)
                print('=> Found pdf file!')
                counter += 1
                found = True
                break

    # check if reference is in dictionary (hard-coded)
    if not found:
        r = ref.split('] ')[1:]
        r = ' '.join(r)
        if r in Bibliography.keys():
            pdf = Bibliography[r][0]
            internal = Bibliography[r][1]
            print(Bibliography[r][0])
            print('=> Found reference in dictionary!')
            counter += 1
            found = True

    # copy files to respective sub-directory
    if found:
        MoveFile = PDFs_sorted + '/' + pdf
        MoveTo = os.path.abspath(PDFs_sorted) + '/../'
        if internal:
            print('Internal paper\n')
            shutil.copy(MoveFile, MoveTo + '01_internal')
            InternalPDFs.append(pdf)
        else:
            print('External paper\n')
            shutil.copy(MoveFile, MoveTo + '02_external')
            ExternalPDFs.append(pdf)
    else:
        print('=> Do it manually!\n')

# move all other files in 04_sorted to 00_not_used
counter_ = 0
for f in RefFiles:
    if f not in ExternalPDFs and f not in InternalPDFs:
        counter_ += 1
        shutil.copy(PDFs_sorted + '/' + f,
                    os.path.abspath(PDFs_sorted) + '/../00_not_used/')

# print statement
print('\n\n==========\nFound ' + str(counter) + '/' + str(len(Bib_OverLeaf)) + ' files!\nMoved ' +
      str(counter_ + len(ExternalPDFs) + len(InternalPDFs)) + '/' + str(len(RefFiles)) + ' pdf files!\n==========')

# moved files
NotUsed = [f for f in os.listdir(PDFs_sorted) if os.path.isfile(os.path.join(
    os.path.abspath(PDFs_sorted) + '/../00_not_used/', f)) and f.endswith('.pdf')]
Internal = [f for f in os.listdir(PDFs_sorted) if os.path.isfile(os.path.join(
    os.path.abspath(PDFs_sorted) + '/../01_internal/', f)) and f.endswith('.pdf')]
External = [f for f in os.listdir(PDFs_sorted) if os.path.isfile(os.path.join(
    os.path.abspath(PDFs_sorted) + '/../02_external/', f)) and f.endswith('.pdf')]
if len(NotUsed) + len(Internal) + len(External) != len(RefFiles):
    print('NotUsed pdf files:   ', NotUsed)
    print('Internal pdf files:  ', Internal)
    print('External pdf files:  ', External)
    print('04_sorted pdf files: ', RefFiles)
    sys.exit('\nNo pdf file should be in sub-directories 00, 01, 02! => rm -rf ... and run this script again!')

# create bibliography for each sub-directory
abs_path_04_sorted = os.path.abspath(PDFs_sorted)
func.CreateBibFile(NotUsed, abs_path_04_sorted,
                   '/../00_not_used/Not_Used_ZoteroBibKey.bib', BibliographyFile)
func.CreateBibFile(Internal, abs_path_04_sorted,
                   '/../01_internal/Internal_ZoteroBibKey.bib', BibliographyFile)
func.CreateBibFile(External, abs_path_04_sorted,
                   '/../02_external/External_ZoteroBibKey.bib', BibliographyFile)
