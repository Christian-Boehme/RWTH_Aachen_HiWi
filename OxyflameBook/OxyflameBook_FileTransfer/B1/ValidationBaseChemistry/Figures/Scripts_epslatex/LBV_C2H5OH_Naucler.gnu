#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#------------------------------------------------------------

set term epslatex standalone color size fh,fw font "Times, 17"
set out '../figures_epslatex/LBV_C2H5OH_Naucler.tex'

set encoding utf8
set termoption enhanced

set xtics 0.4,0.2,2.0
#set ytics 0,0.003,3000
set mxtics 2
set mytics 5

#set title ''
set xlabel '$\mathrm{\phi}$ [-]'
set ylabel '$\mathrm{s_{u}^{0}}$ [cm/s]'# offset 1.0,0
set border lw 1
set xrange [0.40:1.60]
set yrange [0:50]

set multiplot
set format x "%.2f"

# Fix the margins to ensure consistent box size
set lmargin at screen 0.200
set rmargin at screen 0.950
set tmargin at screen 0.925
set bmargin at screen 0.225

# Experiments
f1 = '../ExperimentalData/LBV_C2H5OH_Naucler_T298.txt'
f2 = '../ExperimentalData/LBV_C2H5OH_Naucler_T318.txt'
f3 = '../ExperimentalData/LBV_C2H5OH_Naucler_T338.txt'

# FM simulations
f4 = ARG1
f5 = ARG2
f6 = ARG3
f7 = ARG4
f8 = ARG5
f9 = ARG6

set label 'p = 1 atm' at graph 0.03, graph 0.10

set key at graph 0.975, graph 0.275 spacing 1.0 samplen -1.5
p f1 u 1:($2*1E+00) t 'T = 298 K' w p ps psizeL pt 5 lw plw lc rgb 'blue'\
 ,f4 u ($1):2 notitle w l lt 1 lw lwrefL lc rgb 'blue' dashtype 2\
 ,f5 u ($1):2 notitle w l lt 1 lw lwnewL lc rgb 'blue'\
 ,f2 u 1:($2*1E+00) t 'T = 318 K' w p ps psizeL pt 7 lw plw lc rgb 'black'\
 ,f6 u ($1):2 notitle w l lt 1 lw lwrefL lc rgb 'black' dashtype 2\
 ,f7 u ($1):2 notitle w l lt 1 lw lwnewL lc rgb 'black'\
 ,f3 u 1:($2*1E+00) t 'T = 338 K' w p ps psizeL pt 9 lw plw lc rgb 'red'\
 ,f8 u ($1):2 notitle w l lt 1 lw lwrefL lc rgb 'red' dashtype 2\
 ,f9 u ($1):2 notitle w l lt 1 lw lwnewL lc rgb 'red'\

# ,f1 u 1:($2*1E+00) notitle w p ps psizeL pt 5 lw plw lc rgb 'blue'\
# ,f2 u 1:($2*1E+00) notitle w p ps psizeL pt 7 lw plw lc rgb 'black'\
# ,f3 u 1:($2*1E+00) notitle w p ps psizeL pt 9 lw plw lc rgb 'red'\


unset key
unset multiplot

#-------------------------------------------------------------
