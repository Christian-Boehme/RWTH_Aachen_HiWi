#!/usr/bin/env python3

import re
import sys
import shutil
from core import Functions as func

# input
OverLeaf_bib = sys.argv[1]
Local_bib = sys.argv[2] # internal or external bib-file

# output bibliography file
output_bib = '_'.join(Local_bib[:-4].split('_')[:-1]) + '.bib' # + '_modified.bib'

# create new bibliography file
shutil.copy(Local_bib, output_bib)

# read data
overleaf_bib = func.read_file(OverLeaf_bib)
local_bib = func.read_file(Local_bib)


def remove_space(string):
    return "".join(string.split())


def ExtractKeynameBasedOnTitle(title, data):

    end = -1
    start = -1
    found = False
    for line in range(len(data)):
        #print(remove_space(data[line].lower()))
        if data[line].startswith('@') and found is False:
            start = line
        if data[line] == '}' and found is True:
            end = line + 1
            break
        if remove_space(data[line].lower()).startswith('title={'): # + str(remove_space(title.lower())) + '},':
            RefTitle = '_'.join(re.findall(r"[\w+]+", data[line].lower()))
            #print('RefTitle: ', RefTitle)
            #print(RefTitle)
            if title == 'title_forum_position_paper_the_growing_global_wildland_urban_interface_wui_fire_dilemma_priority_needs_for_research':
                title = 'title_forum_position_paper_the_growing_global_wui_fire_dilemma_priority_needs_for_research'
            if title == 'title_encyclopedia_of_wildfires_and_wildland_urban_interface_wui_fires':
                title = 'title_wildland_urban_interface'
                #if RefTitle.startswith('title_w'):
                print('RefTitle: ', RefTitle)
            if RefTitle == title:
                print('Refer title: ', RefTitle)
                BibTitle = data[line].split('{')[1:] # NOT GOOD
                print('BibTitle: ', BibTitle)
                print('YES')
                found = True
    if start == -1 or end == -1:
        sys.exit('\nCould not find title in bibliography file!')
    
    # extract key
    key = data[start].split('{')[1][:-1] 
    
    return key, BibTitle

#
bib_keys = []
for i in range(len(local_bib)):
    if local_bib[i].startswith('@'):
        local_key = local_bib[i].split('{')[1][:-1]
        #print(local_key)
    if local_bib[i].startswith('	title = {'):
        #title = local_bib[i].split('{')[1]
        #title = title.split('}')[0]
        #print('Local title={' + str(remove_space(title.lower())))
        title = '_'.join(re.findall(r"[\w]+", local_bib[i].lower()))
        print('Local title: ', title)
        # search for respective reference in overleaf_bib
        overleaf_key, overleaf_title = ExtractKeynameBasedOnTitle(title, overleaf_bib)
        # save to list
        bib_keys.append([local_key, overleaf_key])

#print('All detected bib-keys: ', bib_keys)
lkeys = [x[0] for x in bib_keys]
okeys = [x[1] for x in bib_keys]
#if len(lkeys) != len(okeys):
#    sys.exit('\nCould not find all bib-keys!')

# write to file
with open(output_bib, 'w') as out:
    for i in range(len(local_bib)):
        if local_bib[i].startswith('@'):
            #print(local_bib[i])
            reference = local_bib[i].split('{')[0]
            local_key = local_bib[i].split('{')[1][:-1]
            #print('Reference: ', reference)
            #print('Local key: ', local_key)
            idx = lkeys.index(local_key)
            #print(okeys[idx])
            #sys.exit()
            out.write(reference + '{' + okeys[idx] + ',\n')
        else:
            out.write(local_bib[i] + '\n')




#print(overleaf_bib)

