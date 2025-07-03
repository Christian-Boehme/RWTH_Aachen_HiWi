# Overview

1.  Download pdf's
2.  Upload pdf's to Zotero
3.  Remove duplicates based on Zotero
4.  Double check: Tools -> ZotFile Preferences -> RenamingRules : Desired: {%j_}{%y_}{%a_}{%t}
5.  In collection -> click on all elements -> right click -> Manage Attachements -> Rename and Move
6.  Zotero: left side (collection/libraries) -> right click on collection -> Export Collection -> creates *.bib file
7.  6:  Click on all elements -> Open PDF in new window -> Save as ... to 5_All_PDF_Files_AfterZoteroRenaming           ?????
	NOTE: if you rename a file manually (filename structure!) you have to rename the bib entry accordingly
8.  Move pdf files to cluster and rename files with python script
	=> check that name starts with journal (journal must be in dictonary! => output from pyhton script!) - see previous step!
	python3 Scripts/RenamePDFs.py 1_All_PDF_Files_AfterZoteroRenaming/ 2_All_PDF_Files_DesiredFilename
	NOTE: This script MUST rename all pdf succesfully - if not => add journal name and abbreviation to dictionary and run the script again!
9.  Add new bib entries from "Exported Items.bib" (file from Zotero - step 6) to 3_BibFile/DFG_Firebrand_Proposal_AfterZoteroRenaming.bib
10. Modify Bibliography file => rename filenames, similar to step 8
	python3 Scripts/ModifyBibliographyFile.py 3_BibFile/DFG_Firebrand_Proposal_AfterZoteroRenaming.bib 2_All_PDF_Files_DesiredFilename


11. Download the recent proposal and the respective proposal.bib file and copy these two files to the RecentProposal folder
12. Create folder structure
    bash Scripts/CreateFolder_4_Sort_PDF_Files_based_on_Proposal.sh
13. sort pdf files and create a bib file for each 'category' => Double check output manually! (Should detect all pdf files!)
    python3 Scripts/SortFilesIntoCategories.py 4_Sort_PDF_Files_based_on_Proposal/Proposal/Firebrand_Proposal.pdf 4_Sort_PDF_Files_based_on_Proposal/04_sorted
    => NOTE: before you run the script again -> remove the three folders (00_not_used, 01_internal, and 02_external)
14. Rename the bib keys for the internal and external bib files based on the bib-keys used in the proposal bib file
    python3 Scripts/BibKeyModification.py 4_Sort_PDF_Files_based_on_Proposal/Proposal/proposal.bib 4_Sort_PDF_Files_based_on_Proposal/01_internal/Internal_ZoteroBibKey.bib
    python3 Scripts/BibKeyModification.py 4_Sort_PDF_Files_based_on_Proposal/Proposal/proposal.bib 4_Sort_PDF_Files_based_on_Proposal/02_external/External_ZoteroBibKey.bib
    => NOTE: all elements must be found!
15. Upload to sciebo


STEP 9 can be improved and how to do this ... (nice to have)
9:  Move pdf files to 04_sorted (no duplicates) and add corresponding bib elements to DFG_Firebrands_Proposal.bib
	python3 ../../../Scripts/Merge_PDFs_and_Bibliography.py ../6_All_PDF_Files_RenamedPDFs 04_sorted 04_sorted/DFG_Firebrand_Proposal.bib ../7_BibFile/DFG_Firebrand_Proposal_11_12_24_Modified.bib
	NOTE: The 3 directories must be empty!!! & check the output

