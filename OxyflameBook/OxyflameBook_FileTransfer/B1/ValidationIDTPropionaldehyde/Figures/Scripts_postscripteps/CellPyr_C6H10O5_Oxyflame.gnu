#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#-------------------------------------------------------------

set term postscript eps size 5.0, 3.5 font "Times, 46" color
set out '../figures_postscripteps/B1b_Bio_CellulosePyrolysis_C6H10O5.eps'

set encoding utf8
set termoption enhanced

set xtics 0,2,10
set ytics 0,0.1,0.4
set mxtics 1
set mytics 1

#set title ''
set xlabel 'time [s]'
set ylabel 'Y_{C_6H_{10}O_5} [-]' offset 0.5,0
set border lw 2
set xrange [0:8]
set yrange [0:0.4]
set format y "%.1f"
set lmargin at screen 0.30
set rmargin at screen 0.95

set multiplot

# Experiments
f1 = '../ExperimentalData/Fig_5_C6H10O5_700C_exp.csv'
f2 = '../ExperimentalData/Fig_5_C6H10O5_800C_exp.csv'
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
p f3 u ($1/1000):(column('Y_C6H10O5')) notitle w l lt 1 lw lwrefOC lc rgb '#33a02c' dashtype 2\
 ,f4 u ($1/1000):(column('Y_C6H10O5')) notitle w l lt 1 lw lwrefOC lc rgb '#1f78b4' dashtype 2\
 ,f5 u ($1/1000):(column('Y_C6H10O5')) notitle w l lt 1 lw lwrefOC lc rgb '#e31a1c' dashtype 2\
 ,f6 u ($1/1000):(column('Y_C6H10O5')) notitle w l lt 1 lw lwdetOC lc rgb '#33a02c' dashtype 3\
 ,f7 u ($1/1000):(column('Y_C6H10O5')) notitle w l lt 1 lw lwdetOC lc rgb '#1f78b4' dashtype 3\
 ,f8 u ($1/1000):(column('Y_C6H10O5')) notitle w l lt 1 lw lwdetOC lc rgb '#e31a1c' dashtype 3\
 ,f9 u ($1/1000):(column('Y_C6H10O5')) notitle w l lt 1 lw lwnewOC lc rgb '#33a02c'\
 ,f10 u ($1/1000):(column('Y_C6H10O5')) notitle w l lt 1 lw lwnewOC lc rgb '#1f78b4'\
 ,f11 u ($1/1000):(column('Y_C6H10O5')) notitle w l lt 1 lw lwnewOC lc rgb '#e31a1c'\

unset key
unset multiplot
#-------------------------------------------------------------

