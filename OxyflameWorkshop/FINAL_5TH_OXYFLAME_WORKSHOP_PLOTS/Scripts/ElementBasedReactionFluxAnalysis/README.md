# Element reaction flux analysis

__The flux analysis script here differs from the one in the PP-DNS-PostProcessing repo - an additional post-rpocessing step is required here to ignore additional reactions from the NOx-sub-mech. The "Modification" folder refers to this post-processing step.__

The element reaction flux analysis includes a rate of production analysis (ROPA) and reaction pathway analysis 
(RPA) based on the element flux, which is calculated on volumetric average and time-integrated data similar to 
the approach used by [Shamooni et al.](https://linkinghub.elsevier.com/retrieve/pii/S001623612032994X)

## Requirements
The tool requires the following python packages:
~~~~~~~~~~{sh}
pip3 install numpy pandas argparse graphviz networkx matplotlib
~~~~~~~~~~

## Mechanism-dependent-functions
Create the mechanism dependent file which contains the functions to calculate the i.e. the reaction rates 
or production rates:
~~~~~~~~~~{sh}
python3 GenerateMechanismDependentFunctions.py -fh mechanismF90.h -f mechanismF.f90 -k mechanism.mech -t mechanism.chthermo
~~~~~~~~~~
Move the generated file to the `core/` folder:
~~~~~~~~~~{sh}
mv MechanismDependentFunctions.py core/
~~~~~~~~~~
Using a different mechanism requires this step to be carried out again.

## Element flux calculation
The volumetric average and time integrated element flux is caluclated with the command:
~~~~~~~~~~{sh}
python3 FluxAnalysis.py -i VolumetricAverageData.txt -element <element>
~~~~~~~~~~
The script returns an `Output` folder containing the following files:
- `ElementFluxes<element>.csv` contains the species element fluxes in a matrix format which is used for the __RPA__
- `IntegratedNetReactionRate.csv` contains the integrated net reaction rates for the __RPA__
- `SpeciesDestructionRates.csv` includes the species desctruction rates for visulalization
- `SpeciesElementFluxes<element>.csv` includes species element fluxes and the reaction rate for the __ROPA__
- `SpeciesNetProductionRates.csv` includes the net species production rates for visualization
- `SpeciesProductionRates.csv` includes the species production rates for visualization

### Rate of production analysis
The generated `SpeciesElementFluxes<element>.csv` can be used for the rate of production analysis. The base 
command for one input file is:
~~~~~~~~~~{sh}
python3 FluxAnalysis.py -L_ROPA_1 SpeciesElementFluxes<element>.csv -species <species>
~~~~~~~~~~
and i.e. for two input files:
~~~~~~~~~~{sh}
python3 FluxAnalysis.py -L_ROPA_1 SpeciesElementFluxes<element>.csv -L_ROPA_2 SpeciesElementFluxes<element>.csv -label_1 <1st_label> -label_2 <2nd_label> -limit <your_limit> -rcs <R1=red,R2=blue> -species <species>
~~~~~~~~~~
Use `-h` flag to see all options. Required are the flags: `-L_ROPA_1` and `-species`

### Reaction pathway analysis
The generated `ElementFluxes<element>.csv` and `TimeIntegratedNetReactionRate.csv` can be used for the 
reaction pathway analysis. The base command for the reaction pathway analysis is:
~~~~~~~~~~{sh}
python3 FluxAnalysis.py -L_RPA ElementFluxesN.csv -IntRRates TimeIntegratedNetReactionRate.csv -target <initial_species> -species <source> -limit <limit> -NormOutGoing
~~~~~~~~~~
The `target` and `species` flags take species into account from where the graph should start and end  (from target to 
source). Element fluxes below the specified limit are ignored. However, a relatively high limit is not meaningful, 
while a lower limit leads to an unreadable graph. The choice of a meaningful limit is therefore crucial. It is 
recommended to post-process the generated `ElementReactionFluxGraph.dot` file and manually remove some minor/negligible 
pathways (dot -T2pdf ElementReactionFluxGraph.dot -o ElementReactionFluxGraph.pdf). The flag `-NormOutGoing` normalizes 
the element flux by the outgoing element flux of each species, if not specified, the element fluxes are normalized by 
the ingoing element flux of each species.


## Additional scripts
The following scripts are not required for the element flux analysis, but can be used to postprocess the flux analysis data or to visualize production rates.

#### Analysis of dominant precursor
The script returns the sum of all products of pathways from a certain species to another target species (product 
of the path edge weight) based on the RPA graph. Pathways from a start node via another start node to the end 
node are not considered.
`AnalysisOfPrecursor_Thermal_Prompt.py` and `AnalysisOfPrecursor_to_NO_N2.py` are based on the script and take further differences in the pathways into 
account: the proportion of thermal and prompt-NO to NO and the pathways to NO and N2, respectively.
~~~~~~~~~~{sh}
python3 AnalysisOfPrecursor.py -file <file.dot> -start <species> -end <species>
~~~~~~~~~~

#### NO production rate composition (contribution of fuel NO and thermal NO)
This script returns the thermal-NO (Zeldovich CDOT_NO) and the fuel-NO (remaining CDOT_NO) contribution of the 
total NO production rate.
~~~~~~~~~~{sh}
python3 ProductionRateComposition_NO.py -i VolumetricAverageData.txt
~~~~~~~~~~
In addition, the script returns a csv file (`ThermalNOContribution.csv`) including the thermal-NO and fuel-NO 
production rate for each considered time step.

#### Production rate visualization
Species (net) production or destruction rates over time can be visualized with 
~~~~~~~~~~{sh}
python3 FluxAnalysis.py -PRates_1 Output/SpeciesNetProductionRates.csv -species all -label_1 Net
~~~~~~~~~~
If the species flag is set to all, a pdf file is generated including all specified rates. A png file is returned, when using only one species as input.

