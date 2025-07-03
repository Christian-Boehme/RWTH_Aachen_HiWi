# Volumetric average data caluclation

This matlab tool calculates species mass fractions, mole fractions, concentrations, reaction rates, or production rates for the whole (or for a certain range) numerical domain based on the volumetric average or maximum value from each data.out file.


## How to create the mechanism-dependent-functions?
First, create the mechanism dependent functions to caluclate the species fractions, reaction rates, or the species production rates. To create these files run 
~~~~~~~~~~{sh}
python3 GenerateMechanismDependentMatlabFiles.py -fh KineticModelF90.h -f KineticModelF.f90 -k KineticModel.mech
~~~~~~~~~~
The script creates a folder (MechanismDependentFunctions) in which all mechanism-dependent data and functions for the required calculations are saved. Rename the folder and move it to the 'core' directory
~~~~~~~~~~{sh}
mv MechanismDependentFunctions core/<your_choice>
~~~~~~~~~~
Add the folder name to the ComputeVolumetricAveragedData.m file and select the mechanism in the input section.


## How to run the script?
Adjust the input section in ComputeVolumetricAveragedData.m and run the matlab-file.

