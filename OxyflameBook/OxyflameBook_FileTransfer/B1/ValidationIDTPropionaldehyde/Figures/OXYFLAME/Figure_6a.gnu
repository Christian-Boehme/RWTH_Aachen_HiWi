#!/usr/bin/gnuplot -persist

set term postscript eps font "Times, 46" color
set out 'figures/B1b_Bio_Figure_6a.eps'

set encoding utf8
set termoption enhanced

set xtics 0,2,10
set ytics 0,0.015,0.06
set mxtics 1
set mytics 1

#set title ''
set xlabel 'x [mm]'
set ylabel 'X_{C_6H_5OCH_3} [-]'
set border lw 2
set xrange [0:10]
set yrange [0:0.06]
set format y "%.3f"
set rmargin at screen 0.95

set multiplot

# Chen CFB - paper
f1 = '../ExperimentalData/Fig_6a_ToF.txt'
#f2 = '../ExperimentalData/Fig_6a_GCRtQ.txt'
f3 = '../ExperimentalData/Fig_6a_GCDB.txt'
# FM simulations
f5 = ARG1
f6 = ARG2
f7 = ARG3

lwref = 5
lwdet = 15
lwnew = 6
psize = 2.5

#set termoption dashlength 3
set dashtype 6 "_ "
set dashtype 7 ". "

p f1 u ($1):3:4 notitle w filledcurves lc '#99ffcccc'\
 ,f1 u ($1):2 notitle w p pt 2 ps psize lw 3 lc rgb '#e31a1c'\
 ,f3 u ($1):2 notitle w p pt 8 ps psize lw 3 lc rgb '#1f78b4'\
 ,f5 u ($1*1000):(column('X_C6H5OCH3')) notitle w l lt 1 lw lwref lc rgb 'black' dashtype 6\
 ,f6 u ($1*1000):(column('X_C6H5OCH3')) notitle w l lt 1 lw lwdet lc rgb 'black' dashtype 7\
 ,f7 u ($1*1000):(column('X_C6H5OCH3')) notitle w l lt 1 lw lwnew lc rgb 'black'\

# ,f1 u ($1):2 notitle w p pt 2 ps psize lw 3 lc rgb '#e31a1c'\
# ,f3 u ($1):2 notitle w p pt 8 ps psize lw 3 lc rgb '#1f78b4'\

unset key
unset multiplot

#-------------------------------------------------------------
