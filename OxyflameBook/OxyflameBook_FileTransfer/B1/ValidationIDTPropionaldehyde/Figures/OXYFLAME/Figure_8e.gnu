#!/usr/bin/gnuplot -persist

set term postscript eps font "Times, 46" color
set out 'figures/B1b_Bio_Figure_8e.eps'

set encoding utf8
set termoption enhanced

set xtics 0,2,10
set ytics 0,0.001,0.005
set mxtics 1
set mytics 1

#set title ''
set xlabel 'x [mm]'
set ylabel 'X_{C_5H_6} [-]'
set border lw 2
set xrange [0:10]
set yrange [0:0.005]

set multiplot

# Chen CFB - paper
f1 = '../ExperimentalData/Fig_8e_ToF.txt'
f2 = '../ExperimentalData/Fig_8e_GCRtQ.txt'
f3 = '../ExperimentalData/Fig_8e_GCDB.txt'
# FM simulations
f5 = ARG1
f6 = ARG2
f7 = ARG3

set termoption dashlength 3
set dashtype 6 "_   "
set dashtype 7 ". "

p f1 u ($1):2 notitle w p pt 2 ps 3 lw 3 lc rgb '#e31a1c'\
 ,f1 u ($1):3:4 notitle w filledcurves lc '#99ffcccc'\
 ,f2 u ($1):2 notitle w p pt 6 ps 3 lw 3 lc rgb '#33a02c'\
 ,f2 u ($1):3:4 notitle w filledcurves lc '#9990ee90'\
 ,f3 u ($1):2 notitle w p pt 8 ps 3 lw 3 lc rgb '#1f78b4'\
 ,f3 u ($1):3:4 notitle w filledcurves lc '#99add8e6'\
 ,f5 u ($1*1000):(column('X_C5H6')) notitle w l lt 1 lw 3 lc rgb 'black' dashtype 6\
 ,f6 u ($1*1000):(column('X_C5H6')) notitle w l lt 1 lw 15 lc rgb 'black' dashtype 7\
 ,f7 u ($1*1000):(column('X_C5H6')) notitle w l lt 1 lw 6 lc rgb 'black'\
 ,f1 u ($1):2 notitle w p pt 2 ps 3 lw 3 lc rgb '#e31a1c'\
 ,f2 u ($1):2 notitle w p pt 6 ps 3 lw 3 lc rgb '#33a02c'\
 ,f3 u ($1):2 notitle w p pt 8 ps 3 lw 3 lc rgb '#1f78b4'\

unset key
unset multiplot

#-------------------------------------------------------------
