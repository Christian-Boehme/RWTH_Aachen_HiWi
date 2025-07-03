#!/usr/bin/gnuplot -persist

set term epslatex standalone color size 5,3.5 font "Times, 17" # dashlength 1.25
set out 'Figure_8b.tex'

set encoding utf8
set termoption enhanced

set xtics 0,2,10
set ytics 0,0.005,0.025
set mxtics 1
set mytics 1

#set title ''
set xlabel 'x [mm]'
set ylabel '$\mathrm{X_{C_2H_2}}$ [-]'
set border lw 2
set xrange [0:10]
set yrange [0:0.025]
set format y "%.3f"

load 'Setup.gnu'

set rmargin at screen 0.95
set lmargin at screen 0.15
set tmargin at screen 0.95
set bmargin at screen 0.20

set multiplot

# Chen CFB - paper
f1 = '../../ExperimentalData/Fig_8b_ToF.txt'
f2 = '../../ExperimentalData/Fig_8b_GCRtQ.txt'
#f3 = '../../ExperimentalData/Fig_8b_GCDB.txt'
# FM simulations
f5 = ARG1
f6 = ARG2
f7 = ARG3

p f1 u ($1):3:4 notitle w filledcurves lc '#99ffcccc'\
 ,f2 u ($1):3:4 notitle w filledcurves lc '#9990ee90'\
 ,f1 u ($1):2 notitle w p pt 2 ps psize lw plw lc rgb '#e31a1c'\
 ,f2 u ($1):2 notitle w p pt 6 ps psize lw plw lc rgb '#33a02c'\
 ,f5 u ($1*1000):(column('X_C2H2')) notitle w l lt 1 lw lwref lc rgb 'black' dt 6\
 ,f6 u ($1*1000):(column('X_C2H2')) notitle w l lt 1 lw lwdet lc rgb 'black' dt 3\
 ,f7 u ($1*1000):(column('X_C2H2')) notitle w l lt 1 lw lwnew lc rgb 'black'\

# ,f1 u ($1):2 notitle w p pt 2 ps psize lw 3 lc rgb '#e31a1c'\
# ,f2 u ($1):2 notitle w p pt 6 ps psize lw 3 lc rgb '#33a02c'\

unset key
unset multiplot

#-------------------------------------------------------------
