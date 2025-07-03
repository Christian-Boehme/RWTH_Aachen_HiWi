#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#------------------------------------------------------------

set term epslatex standalone color size fh,fw font "Times, 17"
set out '../figures_epslatex/LBV_C2H2.tex'

set encoding utf8
set termoption enhanced

set xtics 0.5,0.2,2.1
#set ytics 0,0.003,3000
set mxtics 2
set mytics 5

#set title ''
set xlabel '$\mathrm{\phi}$ [-]'
set ylabel '$\mathrm{s_{u}^{0}}$ [cm/s]'# offset 1.0,0
set border lw 1
set xrange [0.50:2.10]
set yrange [0:180]

set multiplot
set format x "%.2f"

# Fix the margins to ensure consistent box size
set lmargin at screen 0.200
set rmargin at screen 0.950
set tmargin at screen 0.925
set bmargin at screen 0.225

# Experiments
f1 = '../ExperimentalData/LBV_C2H2_Jomaas.txt'
f2 = '../ExperimentalData/LBV_C2H2_Egolfopoulous.txt'

# FM simulations
f4 = ARG1
f5 = ARG2

set label 'p = 1 atm' at graph 0.70, graph 0.10

set key at graph 0.975, graph 0.275 spacing 1.0 samplen -1.5
p f1 u 1:($2*1E+00) notitle w p ps psize pt 5 lw plw lc rgb 'blue'\
 ,f2 u 1:($2*1E+00) notitle w p ps psize pt 9 lw plw lc rgb 'red'\
 ,f4 u ($1):2 notitle w l lt 1 lw lwrefL lc rgb 'black' dashtype 2\
 ,f5 u ($1):2 notitle w l lt 1 lw lwnewL lc rgb 'black'\

# ,f1 u 1:($2*1E+00) notitle w p ps psize pt 5 lw plw lc rgb 'blue'\
# ,f2 u 1:($2*1E+00) notitle w p ps psize pt 9 lw plw lc rgb 'red'\


unset key
unset multiplot

#-------------------------------------------------------------
