# Scripts folder

For a detailed overview, see the scripts.

## ExtractDissipationElementData
        1. Save_Zst_DE_Gridpoints_to_csv_traj_Tbox_....m
            -> Saves gridpoints (DNS) of each DE with Zst to a file
		2. Save_All_DE_Gridpoints_to_csv_Case_finish.m
            -> Saves gridpoints of each DE to a file
		3. SaveDataRegimeDiagram.m
            -> Saves the following variabels for each DE to a file
                -> DEid, g, dZ, dZr, dZ/dZr
            => NOTE: FILE WAS USED FOR PREVIOUS RESULTS
		4. SaveRespectiveFlameletForEachDissipationElement.m
            -> Two fitting approaches: Tgas or YOH
            -> Respective flamelets are written to a file (DEid, Tinlet, strain rate)

## CreateFigures
        1. AverageRatioCchi_BasedOnDNS.m
            -> Cchi = <chi / (2Dg²)> for all DE or for all Zst DE
        2. AverageRatioCchi_BasedOnFlamelets.m
            => NOTE: FILE WAS USED FOR PREVIOUS RESULTS
		3. DNS_ConditionalMean.m
            -> Plots the conditional mean of several variables (can be specified)
		4. DNS_GradientOverDissipationRate.m
            -> Plots the gradient over the (max) dissipation rate for each (Zst) dissipation element - DNS data
		5. DNS_ReactionZoneThicknessVisualization.m
            -> Plots the heat-release over mixture fraction and caluclates the reaction zone thickness based on the conditional mean - DNS data
        6. RegimeDiagram_ConstantFlameletData.m
            -> Regime diagram based on constant, global flamelet data (quenching point, reaction zone thickness - Tin = mean(Tgas,DE) -> strain rate independent)
            -> Flamelet data are provided from: DetermineQuenchingDissipationRate_FlameletsNicolai.py
            => NOTE: THIS FILE IS NOT IN USE, INITIAL IDEA
        7. RegimeDiagram_FlameletFitting_DissipationRate.m
            -> mean (or min) Tgas & dissipation rate (C_chi * 2 * Dst * g^2) in each dissipation element are used to find the respective flamelet
        8. RegimeDiagram_FlameletFitting_TgasYOH.m
            -> conditional mean of Tgas or YOH (dissipation element) is fitted to all possible flamelets (Tinlet = mean(Tgas,DE) - histogram), nearest flamelet is choosen
                -> YOH fitting: input is: i.e. DE_Flamelets_YOH_PDF_ign.csv
                -> Tgas fitting: input is: i.e. DE_Flamelets_Tgas_PDF_ign.csv
                => These input files are generated with: SaveRespectiveFlameletForEachDissipationElement.m
        9. RegimeDiagram_Threshold.m
            -> Creates profiles based on the different fitting approaches - check how well the fitting approach works
		10. TrajSearch_PostProcessing.m
			-> Creates several figures (2D plots, jpdf, ...) from the DNS data

## Calculations
		1. DetermineQuenchingDissipationRate_FlameletsNicolai.py
			-> creates outputi-file "PostProcessedData/QuenchingData_FlameletsNicolai.csv" with all relevant flamelets (Tinlet, Tgas(Zst), chi(Zst), dZr, gq)
			-> creates image T over chi_st
            => NOTE: THIS FILE IS NOT IN USE, CREATED FOR PREVIOUS RESULTS
