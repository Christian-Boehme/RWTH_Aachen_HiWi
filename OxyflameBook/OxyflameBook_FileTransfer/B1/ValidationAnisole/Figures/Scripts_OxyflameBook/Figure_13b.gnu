#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#-------------------------------------------------------------

set term postscript size fw,fh eps font "Times, 46" color
set out '../figures_OxyflameBook/Figure_13b.eps'

set termoption enhanced
set encoding utf8

set xtics 0,2,10
set ytics 0,0.00008,0.00032
set mxtics 1
set mytics 1

#set title ''
set xlabel 'x [mm]'
#set ylabel 'X_{A_1CHO} [-]'
set border lw 2
set xrange [0:10]
set format y "%.1E"
set yrange [0:0.00032]

# Fix the margins to ensure consistent box size
set lmargin at screen 0.350
set rmargin at screen 0.950
set tmargin at screen 0.925
#set bmargin at screen 0.225

# ylabel position at left border
xpos = 1.50 #1.25
set ylabel 'X_{A_1CHO} [-]' offset xpos,0

set multiplot

# Chen CFB - paper
#f1 = '../ExperimentalData/Fig_13b_ToF.txt'
#f2 = '../ExperimentalData/Fig_13b_GCRtQ.txt'
f3 = '../ExperimentalData/Fig_13b_GCDB.txt'
f4 = '../ExperimentalData/Fig_13b_sim.txt'
# FM simulations
f5 = ARG1
f6 = ARG2
f7 = ARG3

# Create figure
p f3 u ($1):3:4 notitle w filledcurves lc '#99add8e6'\
 ,f3 u ($1):2 notitle w p lt 1 pt 4 ps psize lw plw lc rgb '#1f78b4'\
 ,f5 u ($1*1000):(column('X_C6H5CHO')) notitle w l lt 1 lw lwref lc rgb lcref dashtype 2\
 ,f6 u ($1*1000):(column('X_A1CHO')) notitle w l lt 1 lw lwdet lc rgb 'black' dashtype 3\
 ,f7 u ($1*1000):(column('X_A1CHO')) notitle w l lt 1 lw lwnew lc rgb 'black'\

# ,f3 u ($1):2 notitle w p pt 4 ps psize lw plw lc rgb '#1f78b4'\

unset key
unset multiplot

#-------------------------------------------------------------
