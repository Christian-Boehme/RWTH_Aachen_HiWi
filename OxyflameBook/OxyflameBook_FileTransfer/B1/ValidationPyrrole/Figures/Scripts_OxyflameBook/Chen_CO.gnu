#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#-------------------------------------------------------------

set term postscript size fw,fh eps font "Times, 46" color
set out '../Figures_OxyflameBook/Chen_CO.eps'

set termoption enhanced
set encoding utf8

set xtics 700,200,10000
set ytics 0,5000,20000
set mxtics 2
set mytics 1

#set title ''
set xlabel 'T [K]'
set border lw 2
set xrange [700:1300]
set yrange [0:20000]
#set format y "%.3f"

# Fix margins to ensure consistent box size
set lmargin at screen 0.325
set rmargin at screen 0.925
set tmargin at screen 0.925
#set bmargin at screen 0.225

set multiplot

# Experiments
f1 = '../ExperimentalData/Fig1_b_GC1.csv'
#f2 = '../ExperimentalData/Fig1_b_GCMS2.csv'
#f3 = '../ExperimentalData/Fig1_b_ToFMBMS.csv'
f4 = '../ExperimentalData/Fig1_b_Pelucchi.csv'
# FM simulations
f5 = ARG1
f6 = ARG2
f7 = ARG3

# ylabel position at left border
xpos = 1.25
set ylabel 'X_{CO} [ppm]' offset xpos,0

# create figures
p f1 u ($1):($3*1E+06):($4*1E+06) notitle w filledcurves lc '#99ebbe4d'\
 ,f1 u ($1):($2*1E+06) notitle w p pt symGC1 ps psize lw plw lc rgb lcGC1\
 ,f4 u ($1):($2*1E+06) notitle w p pt symPel ps psize lw plw lc rgb lcPel\
 ,f5 u 1:((column('X-CO'))*1E+06) notitle w l lt 1 lw lwref lc rgb lcref dashtype 2\
 ,f6 u 1:((column('X-CO'))*1E+06) notitle w l lt 1 lw lwdet lc rgb lcdet dashtype 3\
 ,f7 u 1:((column('X-CO'))*1E+06) notitle w l lt 1 lw lwnew lc rgb lcnew\

unset key
unset multiplot
#-------------------------------------------------------------

