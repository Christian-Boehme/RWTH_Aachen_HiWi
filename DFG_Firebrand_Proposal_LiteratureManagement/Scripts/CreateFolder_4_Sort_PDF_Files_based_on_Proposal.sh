#/usr/bin bash

#
mkdir -p 4_Sort_PDF_Files_based_on_Proposal/

#
cd 4_Sort_PDF_Files_based_on_Proposal/

#
mkdir -p 00_not_used
mkdir -p 01_internal
mkdir -p 02_external
#mkdir -p 04_sorted
mkdir -p Proposal

#
cp -r ../2_All_PDF_Files_DesiredFilename/ 04_sorted/

#
cp ../3_BibFile/DFG_Firebrand_Proposal_AfterZoteroRenaming_Modified.bib 04_sorted/DFG_Firebrand_Proposal.bib

#
cp ../RecentProposal/* Proposal
#echo 'Add proposal to directory: 4_Sort_PDF_Files_based_on_Proposal/Proposal'

