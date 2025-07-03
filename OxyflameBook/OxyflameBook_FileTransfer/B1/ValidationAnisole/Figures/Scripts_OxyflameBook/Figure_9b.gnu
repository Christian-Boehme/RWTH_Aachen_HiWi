#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#-------------------------------------------------------------

set term postscript size fw,fh eps font "Times, 46" color
set out '../figures_OxyflameBook/Figure_9b.eps'

set encoding utf8
set termoption enhanced

set xtics 0,2,10
set ytics 0,0.001,0.004
set mxtics 1
set mytics 1

#set title ''
set xlabel 'x [mm]'
#set ylabel 'X_{C_5H_5CH_3} [-]'
set border lw 2
set xrange [0:10]
y_max = 0.004
set yrange [0:y_max]
set format y "%.3f"

# Fix the margins to ensure consistent box size
set lmargin at screen 0.325
set rmargin at screen 0.950
set tmargin at screen 0.925
#set bmargin at screen 0.225

# ylabel position at left border
xpos = 0.25
set ylabel 'X_{C_5H_5CH_3} [-]' offset xpos,0

set multiplot

# Chen CFB - paper
#f1 = '../ExperimentalData/Fig_9b_ToF.txt'
f2 = '../ExperimentalData/Fig_9b_GCRtQ.txt'
#f3 = '../ExperimentalData/Fig_9b_GCDB.txt'
# FM simulations
f5 = ARG1
f6 = ARG2
f7 = ARG3

# Create figure
p f2 u ($1):3:4 notitle w filledcurves lc '#9990ee90'\
 ,f2 u ($1):2 notitle w p pt 6 ps psize lw plw lc rgb '#33a02c'\
 ,f5 u ($1*1000):(column('X_C5H5CH3')) notitle w l lt 1 lw lwref lc rgb lcref dashtype 2\
 ,f6 u ($1*1000):(column('X_C5H5CH3-1')) notitle w l lt 1 lw lwdet lc rgb 'black' dashtype 3\
 ,f7 u ($1*1000):(column('X_C5H5CH3-1')) notitle w l lt 1 lw lwnew lc rgb 'black'\

# ,f2 u ($1):2 notitle w p pt 6 ps psize lw plw lc rgb '#33a02c'\

unset key
unset multiplot

#-------------------------------------------------------------
