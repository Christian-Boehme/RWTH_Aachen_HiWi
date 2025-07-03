#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup_AnisoleOxidation.gnu'
#-------------------------------------------------------------

set term postscript eps font "Times, 46" color
set out '../figures_postscripteps/Figure_8i.eps'

set encoding utf8
set termoption enhanced

set xtics 0,2,10
#set ytics 0,0.01,3000
set mxtics 1
set mytics 1

#set title ''
set xlabel 'x [mm]'
set ylabel 'X_{P-C_3H_4} [-]'
set border lw 2
set xrange [0:10]
#set yrange [0:0.07]

set multiplot

# Chen CFB - paper
#f1 = '../ExperimentalData/Fig_8i_ToF.txt'
f2 = '../ExperimentalData/Fig_8i_GCRtQ.txt'
#f3 = '../ExperimentalData/Fig_8i_GCDB.txt'
# FM simulations
f5 = ARG1
f6 = ARG2
f7 = ARG3

# Create figure
p f2 u ($1):3:4 notitle w filledcurves lc '#9990ee90'\
 ,f2 u ($1):2 notitle w p pt 6 ps psize lw plw lc rgb '#33a02c'\
 ,f5 u ($1*1000):(column('X_C3H4-P')) notitle w l lt 1 lw lwref lc rgb lcref dashtype 2\
 ,f6 u ($1*1000):(column('X_P-C3H4')) notitle w l lt 1 lw lwdet lc rgb 'black' dashtype 3\
 ,f7 u ($1*1000):(column('X_P-C3H4')) notitle w l lt 1 lw lwnew lc rgb 'black'\

# ,f2 u ($1):2 notitle w p pt 6 ps psize lw plw lc rgb '#33a02c'\

unset key
unset multiplot

#-------------------------------------------------------------
