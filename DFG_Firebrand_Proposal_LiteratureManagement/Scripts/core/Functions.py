#!/usr/bin/env python3

import os
import re
import sys
import shutil


def remove_space(string):
    return "".join(string.split())


def read_file(inp):
    with open(inp, 'r') as input:
        return [line.rstrip() for line in input]


def rename_pdf_file(PDF, JAbbrev):

    # allocate memory
    renamed_pdfs = []

    Journal = PDF.split('_')[0]
    if Journal in JAbbrev.keys():
        Abbrev = JAbbrev[Journal]
        new_pdf = Abbrev + '_' + '_'.join(PDF.split('_')[1:])
        new_pdf = new_pdf.replace(" ", "_")
        print(new_pdf)
        if '_et_al' in new_pdf:
            new_pdf = new_pdf.replace('_et_al', '')
        renamed_pdfs.append(new_pdf)
    else:
        print('\nCould not rename pdf: ' + str(PDF) +
              '\n=> Add journal to dictionary!\n')

    return renamed_pdfs


def rename_pdf_files(directory, src_path, JAbbrev, move):

    for filename in os.listdir(directory):
        old_file_path = os.path.join(directory, filename)
        old_pdf = old_file_path.split('/')[-1]
        old_path = old_file_path.split('/')[:-1]
        Journal = old_pdf.split('_')[0]
        if Journal in JAbbrev.keys():
            Abbrev = JAbbrev[Journal]
            new_pdf = Abbrev + '_' + '_'.join(old_pdf.split('_')[1:])
            new_pdf = new_pdf.replace(" ", "_")
            if '_et_al' in new_pdf:
                new_pdf = new_pdf.replace('_et_al', '')
            if move:
                print('Copy the renamed pdf to ' +
                      str(src_path) + ': ' + str(new_pdf))
                new_file_path = src_path + '/' + new_pdf
                shutil.copy(old_file_path, new_file_path)
        else:
            print('\nCould not rename pdf: ' + str(old_pdf) +
                  '\n=> Add journal to dictionary!\n')

    return


def RenameFilenameInBibliography(outfile, f, ref, journals):

    with open(outfile, 'w') as out:
        for line in f:
            if line.startswith('	file = {'):
                # print(line)
                found = False
                old_pdf = line.split(' {')[1]
                old_pdf = old_pdf.split('.pdf:')[0] + '.pdf'
                # print('OLD: ', old_pdf)
                new_pdf = rename_pdf_file(old_pdf, journals)
                new_pdf = new_pdf[0]
                # print('NEW: ', new_pdf)
                # search for pdf file
                for i in ref:
                    if i == new_pdf:
                        # print('Found pdf!')
                        ref.remove(i)
                        found = True
                        break
                if found:
                    line = '	file = {:' + str(new_pdf) + ':PDF},'
                else:
                    sys.exit('\nCould not find file: ' + str(old_pdf) + ' !')
            out.write(line + '\n')
    
    # check if complete
    if len(ref) != 0:
        print('\nWarning: Found the following pdf files without bibliography entry in bib file!')
        for i in ref:
            print(i)

    return


def ExtractBibliography(filename, bib):

    data = read_file(bib)

    end = -1
    start = -1
    for line in range(len(data)):
        if data[line] == '':
            start = line
        if data[line] == '	file = {:' + str(filename) + ':PDF},':
            end = line + 2
            break
    if start == -1 or end == -1:
        sys.exit('\nCould not find pdf in bibliography file!')

    return data[start:end]


def AddBibliography(files, BibLocal, BibGlobal):

    with open(BibGlobal, 'a+') as out:
        for f in files:
            File_Bib = ExtractBibliography(f, BibLocal)
            for line in File_Bib:
                out.write(line + '\n')


def ExtractInformationFromReference(r):

    # reference is the literature element from the pdf file

    # e = False
    # i = False
    a = ''  # author
    # y = '' # year
    t = ''  # title

    # remove number
    r = r.split('] ')[1:]
    r = ''.join(r)

    # find author name -> surname!
    dot_idx = r.find('.')
    com_idx = r.find(',')
    if dot_idx == com_idx == -1:
        sys.exit('\nCould not find any symbol in reference.')
    elif dot_idx == -1:
        sym = ','
    elif com_idx == -1:
        sym = '.'
    else:
        if dot_idx < com_idx:
            sym = '.'
        else:
            sym = ','
    if sym == ',':
        a = r.split(sym)[0]
    else:
        # format first name. last name, ...
        a = r.split(sym)[1]
        a = remove_space(a).split(',')[0]

    # avoid "ä", "ö", "ü"
    if '¨a' in a:
        a = a.replace('¨a', 'ä')
    if '¨o' in a:
        a = a.replace('¨o', 'ö')
    if '¨u' in a:
        a = a.replace('¨u', 'ü')

    # find title
    if '“' in r:
        t = r.split('“')[1]
        t = t.split('”')[0]
    # else:
    #    print('title not found!')

    # reference: internal or external
    # NOTE Don't use this here - if mulile authors are present 'Pitsch' does not occure in author list
    # => use author list in bib file!
    # if 'Pitsch' in r:
    #    i = True
    # else:
    #    e = True

    # print('author: ', a)
    # print('year:   ', y)
    # print('title:  ', t)

    return a, t  # , i, e


def ignore_symbols(s, symbols):

    for sym in symbols:
        s = s.replace(sym, '')

    return s


def CheckIfRefIsInternal(bib, pdf):

    # reference is internal (ITV) if 'Pitsch' is in author list
    i = False
    for line in bib:
        if line.startswith('	author = {'):
            AuthorLine = line
        if line == '	file = {:' + str(pdf) + ':PDF},':
            break
    # print(AuthorLine)
    Author = re.findall(r"[\w']+", AuthorLine)
    if 'Pitsch' in Author:
        i = True

    return i


def CreateBibFile(f, apath, BibFile, Bib):

    #
    f = sorted(f)

    #
    filename = apath + BibFile
    with open(filename, 'w') as out:
        for i in f:
            end = -1
            start = -1
            # print('File: ', i)
            for j in range(len(Bib)):
                if Bib[j] == '':
                    start = j
                if Bib[j] == '	file = {:' + str(i) + ':PDF},':
                    end = j + 2
                    break
            if start == -1 or end == -1:
                sys.exit('\nCould not find pdf in bibliography!')
            for j in range(start, end):
                # print(Bib[j])
                out.write(Bib[j] + '\n')

    print('Created bibliography file: ', filename)

    return
