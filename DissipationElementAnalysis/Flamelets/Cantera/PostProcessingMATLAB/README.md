# Post-process flamelts - MATLAB

For a detailed overview, see the scripts.

## SaveFlameletData.m
Script creates a csv-file containing all relevant variables for further analysis steps.
NOTE: Function: FindIndexOfPeak.m must be considered here also!
We ignore these large reaction zone thicknesses in further steps (see regime diagram).

## CreateFigure_TemperatureOverStoichDissipationRate.m
Calculates g_quenching (global max) and plots Tgas over chi_st for all flamelets.

## CreateFigure_TemperatureOverDissipationRate.m
Plots Tgas over chi for all flamelets (certain strain rate or max strain rate for all flamelets)

## CreateFigure_ReactionZoneThicknessVisualization.m
Plots heat release over mixture fraction - reaction zone thickness visualization by gaussian curve.
For one or all flamelets.
Code can contains FindIdxOfPeak function -> commented out. Function must be improved!

## CreateFigure_ReactionZoneThicknessOverDissipationRateRatio.m
Plots the reaction zone thickness over the dissipation rate ratio (stoichiometric divided by quenching)

## CreateFigure_AnalyseReactionZoneThickness.m
Plots the heat release profile over mixture fraction (left side) and the reaction zone thickness over the 
dissipation rate ratio (stoichiometric divided by quenching).
-> Flamelets with very small strain rates have a double-peak profile -> large reaction zone 
thickness (FindIdxOfPeak function should fix this - see reateFigure_ReactionZoneThicknessVisualization.m)

## Previous notes
### reaction zone thickness
Flamelet (T_inlet=1400K, a=37) = 0.145
DNS (t=0.50ms) = 3.122213e-02
DNS (t=0.65ms) = 2.805733e-01
DNS (t=0.75ms) = 3.621678e-02
DNS (t=1.00ms) = 5.797222e-03

### quenching dissipation rate
Approach chi_quenching = chi_max
Flamelet (T_inlet=1400K, a=37) = 29273.59 1/s

### quenching gradient
g_quenching = sqrt(chi_max / 6 / D)
see print in script: CreateFigure_TemperatureDissipationRateRatio.m
g_quenching = 1.008789e+03 1/m (Tin = 1400 K and a = 37 1/s)
