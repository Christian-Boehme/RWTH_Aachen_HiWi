# Element reaction flux analysis

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
TODO
~~~~~~~~~~{sh}
python3 FluxAnalysis.py -L_RPA ElementFluxesN.csv -IntRRates IntegratedNetReactionRate.csv -target <initial_species> -species <sources> -limit <limit> -NormOutGoing
~~~~~~~~~~

Mass in one node -> limit too high -> decrease limit -> pathway visible, but whole graph is a mess => carefully chose the limit and modify the generated dot file so that no mass end is visible
=> run: dot -Tps2 graph.dot -o graph.eps


## Additional scripts
The following scripts are not required for the element flux analysis, but can be used to postprocess the flux analysis data or to visualize production rates.

#### Analysis of dominant precursor
The script returns the sum of all products of pathways from a certain species to another target species (product 
of the path edge weight) based on the RPA graph. Pathways from a start node via another start node to the end 
node are not considered.
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

#### Production rates visualization
Species (net) production or destruction rates over time can be visualized with 
~~~~~~~~~~{sh}
python3 FluxAnalysis.py -PRates_1 Output/SpeciesNetProductionRates.csv -species all -label_1 Net
~~~~~~~~~~
If the species flag is set to all, a pdf file is generated including all specified rates. A png file is returned, when using only one species as input.

