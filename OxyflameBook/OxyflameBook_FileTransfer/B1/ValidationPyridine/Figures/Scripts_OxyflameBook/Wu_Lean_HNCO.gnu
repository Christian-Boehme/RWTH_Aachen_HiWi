#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#-------------------------------------------------------------

set term postscript size fw,fh eps font "Times, 36" color
set out '../figures_OxyflameBook/Wu_Lean_HNCO.eps'

set termoption enhanced
set encoding utf8

set xtics 100,100,10000
#set ytics 0,0.02,3000
set mxtics 1
set mytics 1

#set title ''
set xlabel 'T [K]'
set border lw 2
set xrange [700:1200]
#set yrange [0:0.12]

# Fix margins to ensure consistent box size
set lmargin at screen 0.225
set rmargin at screen 0.925
set tmargin at screen 0.925
set bmargin at screen 0.225

set multiplot

# Experiments
f1 = '../ExperimentalData/Wu_Lean_HNCO_MBMS.txt'
# FM simulations
f3 = ARG1
f4 = ARG2
f5 = ARG3

# Automatic Y-axis
stats f1 using ($2*1E+06) nooutput
y_max = STATS_max
stats f3 using (column("X-HNCO")*1E+06) nooutput
if (STATS_max > y_max) {y_max = STATS_max}
stats f4 using (column("X-HNCO")*1E+06) nooutput
if (STATS_max > y_max) {y_max = STATS_max}
stats f5 using (column("X-HNCO")*1E+06) nooutput
if (STATS_max > y_max) {y_max = STATS_max}
call "AutomaticYAxis.gnu" sprintf("%i", y_max)
set ytics y_max/ntics
set yrange[0:y_max]

# ylabel position at left border
xpos = 0.0
if (y_max >= 1E+04) {xpos = 2.5}
if (y_max < 1E+04) {xpos = 1.5}
if (y_max < 1E+03) {xpos = 0.5}
if (y_max < 1E+02) {xpos = -0.5}
set ylabel 'X_{HNCO} [ppm]' offset xpos,0

# create figures
p f1 u 1:($2*1E+06) notitle w p ps psizeWL lw plw pt 7 lc rgb lcsymWL\
 ,f3 u 1:((column('X-HNCO'))*1E+06) notitle w l lt 1 lw lwrefWL lc rgb lcrefWL dashtype 2\
 ,f4 u 1:((column('X-HNCO'))*1E+06) notitle w l lt 1 lw lwdetWL lc rgb lcdetWL dashtype 3\
 ,f5 u 1:((column('X-HNCO'))*1E+06) notitle w l lt 1 lw lwnewWL lc rgb lcnewWL\

# ,f1 u 1:($2*1E+06) notitle w p ps psizeWL lw plw pt 7 lc rgb lcsymWL\

unset key
unset multiplot
#-------------------------------------------------------------

