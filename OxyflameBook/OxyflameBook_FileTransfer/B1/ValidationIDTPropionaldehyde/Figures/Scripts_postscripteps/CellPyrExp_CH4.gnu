#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#-------------------------------------------------------------

set term postscript size fw,fh eps font "Times, 36" color
set out '../figures_postscripteps/CellulosePyrolysisExperiment_CH4.eps'

set encoding utf8
set termoption enhanced

set xtics 0,2,10
set ytics 0,0.02,0.10
set mxtics 1
set mytics 1

#set title ''
#set xlabel 'time [s]'
#set ylabel 'Y_{CH_4} [-]'
set border lw 2
set xrange [0:8]
set yrange [0:0.10]
set format y "%.2f"

# Fix the margins to ensure consistent box size
set lmargin at screen 0.280
set rmargin at screen 0.950
set tmargin at screen 0.925
set bmargin at screen 0.225

# ylabel position at left border
xpos = -1.75
set ylabel 'Y_{CH_4} [-]' offset xpos,0

set multiplot

# Experiments
f1 = '../ExperimentalData/Fig_5_CH4_700C_exp.csv'
f2 = '../ExperimentalData/Fig_5_CH4_800C_exp.csv'
# FM simulations
f3  = ARG1
f5  = ARG2
f9  = ARG3
f11 = ARG4

# Create figure
p f1 u ($1):2 notitle w p pt 5 ps psize lw plw lc rgb 'blue'\
 ,f2 u ($1):2 notitle w p pt 7 ps psize lw plw lc rgb 'red'\
 ,f3 u ($1/1000):(column('Y_CH4')) notitle w l lt 1 lw lwrefCE lc rgb 'blue' dashtype 2\
 ,f5 u ($1/1000):(column('Y_CH4')) notitle w l lt 1 lw lwrefCE lc rgb 'red' dashtype 2\
 ,f9 u ($1/1000):(column('Y_CH4')) notitle w l lt 1 lw lwnewCE lc rgb 'blue'\
 ,f11 u ($1/1000):(column('Y_CH4')) notitle w l lt 1 lw lwnewCE lc rgb 'red'\

# ,f1 u ($1):2 notitle w p pt 5 ps psize lw plw lc rgb 'blue'\
# ,f2 u ($1):2 notitle w p pt 7 ps psize lw plw lc rgb 'red'\

unset key
unset multiplot
#-------------------------------------------------------------

