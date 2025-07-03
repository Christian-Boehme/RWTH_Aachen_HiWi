#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#-------------------------------------------------------------

set term postscript size 5, 3.5 eps font "Times, 36" color
set out '../figures_postscripteps/Glarborg2018_ThermalDeNOx_O250.eps'

set termoption enhanced
set encoding utf8

set mxtics 1
set mytics 1

#set title ''
set xlabel 'T [K]'
set ylabel 'X [ppm]'
set border lw 1
set xrange [1000:1400]
set yrange [0:600]
set xtics 1000,100,1500
set ytics 0,150,600

set multiplot

# Experiments
f1 = '../ExperimentalData/ThermalDeNOx/FR_NO_50O.txt'
#f2 = '../ExperimentalData/ThermalDeNOx/.txt'
#f3 = '../ExperimentalData/ThermalDeNOx/.txt'
# FM simulations
f4 = ARG1
f5 = ARG2
f6 = ARG3

set label 'X_{O_2} = 0.50' at graph 0.03, graph 0.10

set key at graph 0.225, graph 0.25 spacing 1.0 samplen -1.5
p f1 u 1:($2*1E+00) notitle w p ps 3 lw 3 pt 7 lc rgb 'blue'\
 ,f4 u ($1):((column('X-NO_0'))*1E+00) notitle w l lt 1 lw lwrefG lc rgb 'blue' dashtype 2\
 ,f5 u ($1):((column('X-NO_0'))*1E+00) notitle w l lt 1 lw lwdetG lc rgb 'blue' dashtype 3\
 ,f6 u ($1):((column('X-NO_0'))*1E+00) notitle w l lt 1 lw lwnewG lc rgb 'blue'\

# ,f1 u 1:($2*1E+00) notitle w p ps 3 lw 3 pt 7 lc rgb 'blue'\

unset key
unset multiplot
#-------------------------------------------------------------

