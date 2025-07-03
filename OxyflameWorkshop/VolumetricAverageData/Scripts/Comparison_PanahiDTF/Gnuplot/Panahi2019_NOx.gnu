#!/usr/bin/gnuplot -persist

set term postscript size 5,3.5 eps font "Times, 32" color
set out 'figures/Panahi2019_NOx.eps'

set termoption enhanced
set encoding utf8

set xtics 1200,100,1700
set ytics 0,200,3000
set mxtics 1
set mytics 2

set xlabel 'T_{Furnace} [K]'
set ylabel 'X_{NO_{x,exit}} [ppm]'
set border lw 2
set xrange [1250:1550]
set yrange [0:1000]

set multiplot

f1 = 'Inputs_Panahi2019/DTF_Experiments_Panahi2019_NOx.txt'
f2 = 'Inputs_Panahi2019/CRECKSC_NOx_1s.txt'
f3 = 'Inputs_Panahi2019/Comparison.txt'

factor1 = 40.07 # surface
factor2 = 15.86 # volume flow
factorDp = 1 # size particle
factor11 = 74 #21.305 *3 # 140µm  * 48 cells 
factor288 = 60.13
Diff = 95 # [ppm]

set key at graph 0.59, graph 0.97
set key spacing 1.0
p f1 u 1:2:4:3 t 'Panahi et al.' w errorlines lt 1 lw 4 ps 3 pt 2 lc rgb 'black'\
 ,f2 u ($1):(($4*1E+00*factor288 - Diff)*factorDp) t 'Simulation' w lp lt 1 ps 3 pt 9 lw 4 lc rgb 'red'\
 ,f3 u ($1):($2*1E+00*factor288) t 'Injection: 24' w lp lt 1 ps 3 pt 9 lw 4 lc rgb 'blue' dashtype 2\

# ,f3 u ($1):($3*1E+00*factor288) t 'Injection: 0' w lp lt 1 ps 3 pt 9 lw 4 lc rgb 'blue'\


unset key
unset multiplot
#-------------------------------------------------------------

