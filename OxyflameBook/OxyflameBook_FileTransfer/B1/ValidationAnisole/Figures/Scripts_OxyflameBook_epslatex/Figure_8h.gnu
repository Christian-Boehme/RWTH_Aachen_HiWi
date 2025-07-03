#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#-------------------------------------------------------------

set term epslatex standalone color size fh,fw font "Times, 20"
set out '../figures_OxyflameBook_epslatex/Figure_8h.tex'

set encoding utf8
set termoption enhanced

set xtics 0,2,10
set ytics 0,0.0001,0.0004
set mxtics 1
set mytics 1

#set title ''
set xlabel '$x$ [mm]'
#set ylabel 'X_{A-C_3H_4} [-]'
set border lw 2
set xrange [0:10]
set format y "%.1E"
set yrange [0:0.0004]

# Fix margins to ensure consistent box size
set lmargin at screen 0.280
set rmargin at screen 0.950
set tmargin at screen 0.925
set bmargin at screen 0.225

# ylabel position at left border
xpos = 1.25
set ylabel '$X_\mathrm{A-C_3H_4}$ [-]' offset xpos,0

set multiplot

# Chen CFB - paper
#f1 = '../ExperimentalData/Fig_8h_ToF.txt'
f2 = '../ExperimentalData/Fig_8h_GCRtQ.txt'
#f3 = '../ExperimentalData/Fig_8h_GCDB.txt'
# FM simulations
f5 = ARG1
f6 = ARG2
f7 = ARG3

# Create figure
p f2 u ($1):3:4 notitle w filledcurves lc '#9990ee90'\
 ,f2 u ($1):2 notitle w p pt 6 ps psize lw plw lc rgb '#33a02c'\
 ,f5 u ($1*1000):(column('X_C3H4-A')) notitle w l lt 1 lw lwref lc rgb lcref dashtype 2\
 ,f6 u ($1*1000):(column('X_A-C3H4')) notitle w l lt 1 lw lwdet lc rgb 'black' dashtype 3\
 ,f7 u ($1*1000):(column('X_A-C3H4')) notitle w l lt 1 lw lwnew lc rgb 'black'\

# ,f2 u ($1):2 notitle w p pt 6 ps psize lw plw lc rgb '#33a02c'\

unset key
unset multiplot

#-------------------------------------------------------------
