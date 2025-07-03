#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#-------------------------------------------------------------

set term postscript size fw,fh eps font "Times, 36" color
set out '../figures_postscripteps/CellulosePyrolysis_C5H4O2.eps'

set encoding utf8
set termoption enhanced

set xtics 0,2,10
set ytics 0,0.007,0.028
set mxtics 1
set mytics 1

#set title ''
set xlabel 'time [s]'
#set ylabel 'Y_{C_5H_4O_2} [-]'
set border lw 2
set xrange [0:8]
set yrange [0:0.028]
set format y "%.3f"

# Fix the margins to ensure consistent box size
set lmargin at screen 0.280
set rmargin at screen 0.950
set tmargin at screen 0.925
set bmargin at screen 0.225

# ylabel position at left border
xpos = -0.75
set ylabel 'Y_{C_5H_4O_2} [-]' offset xpos,0

set multiplot

# Experiments
#f1 = '../ExperimentalData/Fig_5_Y_C5H4O2_700C_exp.csv'
#f2 = '../ExperimentalData/Fig_5_Y_C5H4O2_800C_exp.csv'
# FM simulations
f3  = ARG1
f4  = ARG2
f5  = ARG3
f6  = ARG4
f7  = ARG5
f8  = ARG6
f9  = ARG7
f10 = ARG8
f11 = ARG9

# Create figure
p f3 u ($1/1000):(column('Y_C5H4O2')) notitle w l lt 1 lw lwrefC lc rgb 'blue' dashtype 2\
 ,f4 u ($1/1000):(column('Y_C5H4O2')) notitle w l lt 1 lw lwrefC lc rgb '#008000' dashtype 2\
 ,f5 u ($1/1000):(column('Y_C5H4O2')) notitle w l lt 1 lw lwrefC lc rgb 'red' dashtype 2\
 ,f6 u ($1/1000):(column('Y_C5H4O2')) notitle w l lt 1 lw lwdetC lc rgb 'blue' dashtype 3\
 ,f7 u ($1/1000):(column('Y_C5H4O2')) notitle w l lt 1 lw lwdetC lc rgb '#008000' dashtype 3\
 ,f8 u ($1/1000):(column('Y_C5H4O2')) notitle w l lt 1 lw lwdetC lc rgb 'red' dashtype 3\
 ,f9 u ($1/1000):(column('Y_C5H4O2')) notitle w l lt 1 lw lwnewC lc rgb 'blue'\
 ,f10 u ($1/1000):(column('Y_C5H4O2')) notitle w l lt 1 lw lwnewC lc rgb '#008000'\
 ,f11 u ($1/1000):(column('Y_C5H4O2')) notitle w l lt 1 lw lwnewC lc rgb 'red'\

unset key
unset multiplot
#-------------------------------------------------------------

