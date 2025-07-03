#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup_ReducedPyridine.gnu'
#-------------------------------------------------------------

set term postscript size fw,fh eps font "Times, 46" color
set out '../figures_postscripteps/Alzueta_NO_Set3.eps'

set termoption enhanced
set encoding utf8

set xtics 600,300,10000
#set ytics 0,0.02,3000
set mxtics 3
set mytics 1

#set title ''
#set xlabel 'T [K]'
set ylabel 'X_{NO} [ppm]'
set border lw 2
set xrange [600:1500]
#set yrange [0:400]

# Fix margins to ensure consistent box size
set lmargin at screen 0.280
set rmargin at screen 0.900
#set tmargin at screen 0.925
#set bmargin at screen 0.300

set multiplot

# Experiments
f1 = '../ExperimentalData/Alzueta_NO_Set3.txt'
# FM simulations
f2 = ARG1
f3 = ARG2
f4 = ARG3

# Automatic Y-axis
stats f1 using ($2*1E+06) nooutput
y_max = STATS_max
stats f2 using (column("X-NO")*1E+06) nooutput
if (STATS_max > y_max) {y_max = STATS_max}
stats f3 using (column("X-NO")*1E+06) nooutput
if (STATS_max > y_max) {y_max = STATS_max}
stats f4 using (column("X-NO")*1E+06) nooutput
if (STATS_max > y_max) {y_max = STATS_max}
call "AutomaticYAxis.gnu" sprintf("%i", y_max)
set ytics y_max/ntics
set yrange[0:y_max]

# ylabel position at left border
xpos = 0.0
if (y_max >= 1E+04) {xpos = 0.5}
if (y_max < 1E+04) {xpos = 2.0}
if (y_max < 1E+03) {xpos = 1.0}
if (y_max < 1E+02) {xpos = 0.0}
if (y_max < 1E+01) {xpos = -1.0}
set ylabel 'X_{NO} [ppm]' offset xpos,0

set label '{/Symbol l} = 0.4' at graph 0.03, graph 0.90

# create figure
p f1 u 1:($2*1E+06) notitle w p ps psizeA lw plw pt 7 lc rgb lcsymA\
 ,f2 u 2:((column('X-NO'))*1E+06) notitle w l lt 1 lw lwrefA lc rgb lcrefA dashtype 2\
 ,f3 u 2:((column('X-NO'))*1E+06) notitle w l lt 1 lw lwdetA lc rgb lcdetA dashtype 3\
 ,f4 u 2:((column('X-NO'))*1E+06) notitle w l lt 1 lw lwnewA lc rgb lcnewA\

# ,f1 u 1:($2*1E+06) notitle w p ps psizeA lw plw pt 7 lc rgb lcsymA\

unset key
unset multiplot
#-------------------------------------------------------------

