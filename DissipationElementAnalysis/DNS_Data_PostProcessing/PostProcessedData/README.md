# Data-structure


## File: AverageRatioCchi_BasedOnDNS....csv
Contains the Cchi parameter for the first three simulation cases.
Generated with file: ../Scripts/CreateFigures/AverageRatioCchi_BasedOnDNS.m

## File: DE_Flamelets....csv
Contains the DE(id) and the fitted flamelet inlet temperature and the strain rate iteration number.
Created with: ../Scripts/ExtractDissipationElementData/SaveRespectiveFlameletForEachDissipationElement.m

## File: DEGridpoints....csv
one column is one DE
row 1:  element id (number of dissipation element)
row 2:  x-coordinate (cell1)
row 3:  y-coordinate (cell1)
row 4:  z-coordinate (cell1)
row 5:  x-coordinate (cell2)
...  :  ...
NOTE: all columns (=DE) have the same number of rows to save the data (matrix)
    => since not all DE have the same number of grid points -> "0" are added
       to ensure the same array length. "0" is the placeholder.
    => To read the files (and ignore the "0") use: DE_GetGridPoints.m

-> Generated with: ../Scripts/ExtractDissipationElementData/Save_All_DE_Gridpoints_to_csv_Case....m

### Files which are not longer in use

## File: QuenchingData_FlameletsNicolai.csv
Contains Tinlet, Tgas, chi, dZr, g_q for all flamelets at max strain rate iteration. 
-> Generated with: ../Scripts/Calculations/DetermineQuenchingDissipationRate_FlameletsNicolai.py

## File: RegimeDiagramData...
one column is one DE
row 1:  element id (number of dissipation element)
row 2:  g
row 3:  dZ
row 4:  dZr (reaction zone thickness)
row 5:  dZ/dZr
-> Generated with: ../Scripts/ExtractDissipationElementData/SaveDataRegimeDiagram.m
