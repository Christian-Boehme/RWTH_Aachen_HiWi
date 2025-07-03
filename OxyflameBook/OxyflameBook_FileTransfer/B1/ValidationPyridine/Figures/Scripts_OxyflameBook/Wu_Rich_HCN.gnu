#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#-------------------------------------------------------------

set term postscript size fw,fh eps font "Times, 36" color
set out '../figures_OxyflameBook/Wu_Rich_HCN.eps'

set termoption enhanced
set encoding utf8

set xtics 100,100,10000
#set ytics 0,0.02,3000
set mxtics 1
set mytics 1

#set title ''
set xlabel 'T [K]'
#set ylabel 'X_{HCN} [ppm]'
set border lw 2
set xrange [700:1100]
#set yrange [0:0.12]

# Fix margins to ensure consistent box size
set lmargin at screen 0.225
set rmargin at screen 0.925
set tmargin at screen 0.925
set bmargin at screen 0.225

set multiplot

# Experiments
f1 = '../ExperimentalData/Wu_Rich_HCN.txt'
# FM simulations
f3 = ARG1
f4 = ARG2
f5 = ARG3

# Automatic Y-axis
y_max = 6000
ntics = 3
set ytics y_max/ntics
set yrange[0:y_max]

# ylabel position at left border
xpos = 0.0
if (y_max >= 1E+04) {xpos = 2.5}
if (y_max < 1E+04) {xpos = 1.5}
if (y_max < 1E+03) {xpos = 0.5}
if (y_max < 1E+02) {xpos = -0.5}
if (y_max < 1E+01) {xpos = -1.5}
set ylabel 'X_{HCN} [ppm]' offset xpos,0

# create figures
p f1 u 1:($2*1E+00) notitle w p ps psizeWR lw plw pt 7 lc rgb lcsymWR\
 ,f3 u 1:((column('X-HCN'))*1E+06) notitle w l lt 1 lw lwrefWR lc rgb lcrefWR dashtype 2\
 ,f4 u 1:((column('X-HCN'))*1E+06) notitle w l lt 1 lw lwdetWR lc rgb lcdetWR dashtype 3\
 ,f5 u 1:((column('X-HCN'))*1E+06) notitle w l lt 1 lw lwnewWR lc rgb lcnewWR\

# ,f1 u 1:($2*1E+00) notitle w p ps psizeWR lw plw pt 7 lc rgb lcsymWR\

unset key
unset multiplot
#-------------------------------------------------------------

