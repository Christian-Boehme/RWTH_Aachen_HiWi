#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#------------------------------------------------------------

set term postscript size fw,fh eps font "Times, 36" color
set out '../figures_postscripteps/LBV_CH4_Mazas.eps'

set encoding utf8
set termoption enhanced

set xtics 0.4,0.2,2.0
#set ytics 0,0.003,3000
set mxtics 2
set mytics 5

set xlabel '{/Symbol f} [-]'
set ylabel 's_{u}^{0} [cm/s]' offset 1.0,0
set border lw 2
set xrange [0.40:1.60]
set yrange [0:350]

set multiplot
set format x "%.2f"

# Fix the margins to ensure consistent box size
set lmargin at screen 0.225
set rmargin at screen 0.950
set tmargin at screen 0.925
set bmargin at screen 0.225

# Experiments
f1 = '../ExperimentalData/LBV_CH4_Mazas_20.txt'
f2 = '../ExperimentalData/LBV_CH4_Mazas_40.txt'

# FM simulations
f4 = ARG1
f5 = ARG2
f6 = ARG3
f7 = ARG4

set label 'p = 1 atm, T = 373 K' at graph 0.03, graph 0.10

set key at graph 0.975, graph 0.95 spacing 1.0 samplen -1.5
p f1 u 1:($2*1E+00):3:4 t 'X_{CO_2} = 0.20' w errorbars ps psize pt 5 lw plw lc rgb 'blue'\
 ,f4 u ($1):2 notitle w l lt 1 lw lwrefL lc rgb 'blue' dashtype 2\
 ,f5 u ($1):2 notitle w l lt 1 lw lwnewL lc rgb 'blue'\
 ,f2 u 1:($2*1E+00) t 'X_{CO_2} = 0.40' w p ps psize pt 7 lw plw lc rgb 'red'\
 ,f6 u ($1):2 notitle w l lt 1 lw lwrefL lc rgb 'red' dashtype 2\
 ,f7 u ($1):2 notitle w l lt 1 lw lwnewL lc rgb 'red'\

# ,f1 u 1:($2*1E+00):3:4 notitle w errorbars ps psize pt 5 lw plw lc rgb 'blue'\
# ,f2 u 1:($2*1E+00) notitle w p ps psize pt 7 lw plw lc rgb 'red'\


unset key
unset multiplot

#-------------------------------------------------------------
