#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#-------------------------------------------------------------

set term epslatex standalone color size fh,fw font "Times, 20"
set out '../figures_epslatex/Figure_3c.tex'

set encoding utf8
set termoption enhanced

set xtics 0,2,10
set ytics 0,0.15,0.6
set mxtics 1
set mytics 1

#set title ''
#set xlabel 'x [mm]'
#set ylabel 'X_{O_2} [-]'
set border lw 2
set xrange [0:10]
y_max = 0.6
set yrange [0:y_max]
set format y "%.2f"

# Fix the margins to ensure consistent box size
set lmargin at screen 0.250
set rmargin at screen 0.950
set tmargin at screen 0.925
set bmargin at screen 0.225

# ylabel position at left border
xpos = -0.50
set ylabel '$\mathrm{X_{O_2}}$ [-]' offset xpos,0

set multiplot

# Chen CFB - paper
f1 = '../ExperimentalData/Fig_3c_ToF.txt'
#f2 = '../ExperimentalData/Fig_3c_GCRtQ.txt'
#f3 = '../ExperimentalData/Fig_3c_GCDB.txt'
# FM simulations
f5 = ARG1
f6 = ARG2
f7 = ARG3

# Create figure
p f1 u ($1):3:4 notitle w filledcurves lc '#99ffcccc'\
 ,f1 u ($1):2 notitle pt 2 ps psize lw plw lc rgb 'red'\
 ,f5 u ($1*1000):(column('X_O2')) notitle w l lt 1 lw lwref lc rgb lcref dashtype 2\
 ,f6 u ($1*1000):(column('X_O2')) notitle w l lt 1 lw lwdet lc rgb lcdet dashtype 3\
 ,f7 u ($1*1000):(column('X_O2')) notitle w l lt 1 lw lwnew lc rgb lcnew\

# ,f1 u ($1):2 notitle pt 2 ps psize lw plw lc rgb 'red'\

unset key
unset multiplot

#-------------------------------------------------------------
