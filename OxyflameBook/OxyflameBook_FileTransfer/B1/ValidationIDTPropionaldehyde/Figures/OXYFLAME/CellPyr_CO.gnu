#!/usr/bin/gnuplot -persist

set term postscript eps font "Times, 46" color
set out 'figures/B1b_Bio_CellulosePyrolysis_CO.eps'

set encoding utf8
set termoption enhanced

set xtics 0,2,10
set ytics 0,0.15,0.75
set mxtics 1
set mytics 1

#set title ''
set xlabel 'time [s]'
set ylabel 'Y_{CO} [-]'
set border lw 2
set xrange [0:8]
set yrange [0:0.75]
set format y "%.2f"

set multiplot

# Experiments
f1 = '../ExperimentalData/Fig_5_CO_700C_exp.csv'
f2 = '../ExperimentalData/Fig_5_CO_800C_exp.csv'
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

set termoption dashlength 3
set dashtype 6 "_   "
set dashtype 7 ". "

p f3 u ($1/1000):(column('Y_CO')) notitle w l lt 1 lw 3 lc rgb '#33a02c' dashtype 6\
 ,f4 u ($1/1000):(column('Y_CO')) notitle w l lt 1 lw 3 lc rgb '#1f78b4' dashtype 6\
 ,f5 u ($1/1000):(column('Y_CO')) notitle w l lt 1 lw 3 lc rgb '#e31a1c' dashtype 6\
 ,f6 u ($1/1000):(column('Y_CO')) notitle w l lt 1 lw 15 lc rgb '#33a02c' dashtype 7\
 ,f7 u ($1/1000):(column('Y_CO')) notitle w l lt 1 lw 15 lc rgb '#1f78b4' dashtype 7\
 ,f8 u ($1/1000):(column('Y_CO')) notitle w l lt 1 lw 15 lc rgb '#e31a1c' dashtype 7\
 ,f9 u ($1/1000):(column('Y_CO')) notitle w l lt 1 lw 6 lc rgb '#33a02c'\
 ,f10 u ($1/1000):(column('Y_CO')) notitle w l lt 1 lw 6 lc rgb '#1f78b4'\
 ,f11 u ($1/1000):(column('Y_CO')) notitle w l lt 1 lw 6 lc rgb '#e31a1c'\

unset key
unset multiplot
#-------------------------------------------------------------

