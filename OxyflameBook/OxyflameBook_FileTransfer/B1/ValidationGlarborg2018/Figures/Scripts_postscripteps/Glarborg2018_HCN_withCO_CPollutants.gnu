#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#-------------------------------------------------------------

set term postscript size 5, 3.5 eps font "Times, 36" color
set out '../figures_postscripteps/Glarborg2018_HCN_withCO_CPollutants.eps'

set termoption enhanced
set encoding utf8

set mxtics 1
set mytics 1

#set title ''
#set xlabel 'T [K]'
set ylabel 'X [ppm]' offset 1.0,0
set border lw 1
set xrange [900:1400]
set yrange [0:3000]
set xtics 900,100,1500
set ytics 0,1000,3000
set lmargin at screen 0.245
set bmargin at screen 0.225

set multiplot

# Experiments
f1 = '../ExperimentalData/HCN/HCN_CO10_COFR.txt'
f2 = '../ExperimentalData/HCN/HCN_CO10_CO2FR.txt'
#f3 = '../ExperimentalData/HCN/.txt'
# FM simulations
f4 = ARG1
f5 = ARG2
f6 = ARG3

set key at graph 0.975, graph 0.97 spacing 1.1 samplen -1.5
p f1 u 1:($2*1E+01) t 'CO' w p ps 3 lw 3 pt 7 lc rgb 'blue'\
 ,f2 u 1:($2*1E+01) t 'CO_2' w p ps 3 lw 3 pt 9 lc rgb 'black'\
 ,f4 u ($1):((column('X-CO_0'))*1E+01) notitle w l lt 1 lw lwrefG lc rgb 'blue' dashtype 2\
 ,f4 u ($1):((column('X-CO2_0'))*1E+01) notitle w l lt 1 lw lwrefG lc rgb 'black' dashtype 2\
 ,f5 u ($1):((column('X-CO_0'))*1E+01) notitle w l lt 1 lw lwdetG lc rgb 'blue' dashtype 3\
 ,f5 u ($1):((column('X-CO2_0'))*1E+01) notitle w l lt 1 lw lwdetG lc rgb 'black' dashtype 3\
 ,f6 u ($1):((column('X-CO_0'))*1E+01) notitle w l lt 1 lw lwnewG lc rgb 'blue'\
 ,f6 u ($1):((column('X-CO2_0'))*1E+01) notitle w l lt 1 lw lwnewG lc rgb 'black'\

# ,f1 u 1:($2*1E+01) notitle w p ps 3 lw 3 pt 7 lc rgb 'blue'\
# ,f2 u 1:($2*1E+01) notitle w p ps 3 lw 3 pt 9 lc rgb 'black'\

unset key
unset multiplot
#-------------------------------------------------------------

