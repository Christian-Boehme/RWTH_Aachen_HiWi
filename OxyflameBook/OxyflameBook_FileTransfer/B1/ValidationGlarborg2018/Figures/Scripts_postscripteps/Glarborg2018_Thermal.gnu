#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#-------------------------------------------------------------

set term postscript size 5, 3.5 eps font "Times, 24" color
set out '../figures_postscripteps/Glarborg2018_Thermal.eps'

set termoption enhanced
set encoding utf8

set mxtics 1
set mytics 1

#set title ''
set xlabel 'time [ms]'
set ylabel 'C [mol/cm^3]'
set border lw 1
set xrange [0:1]
set yrange [0:8E-8]
set format y "%.1E"
set xtics 0,0.2,1
set ytics 0,2E-8,1E-7

set multiplot

# Experiments
f1 = '../ExperimentalData/Thermal/ThermalNO_Lean.txt'
f2 = '../ExperimentalData/Thermal/ThermalOH_Lean.txt'
#f3 = '../ExperimentalData/NH3/.txt'
# FM simulations
f4 = ARG1
f5 = ARG2
f6 = ARG3

# old key position: 0.975, 0.97
set key at graph 0.975, graph 0.20 spacing 1.25 samplen -1.5
p f1 u 1:($2*1E+00) t 'NO' w p ps 3 lw 3 pt 7 lc rgb 'blue'\
 ,f2 u 1:($2*1E+00) t 'OH' w p ps 3 lw 3 pt 9 lc rgb 'black'\
 ,f4 u ($1):((column('C-NO_0'))*1E+00) notitle w l lt 1 lw lwrefG lc rgb 'blue' dashtype 2\
 ,f4 u ($1):((column('C-OH_0'))*1E+00) notitle w l lt 1 lw lwrefG lc rgb 'black' dashtype 2\
 ,f5 u ($1):((column('C-NO_0'))*1E+00) notitle w l lt 1 lw lwdetG lc rgb 'blue' dashtype 3\
 ,f5 u ($1):((column('C-OH_0'))*1E+00) notitle w l lt 1 lw lwdetG lc rgb 'black' dashtype 3\
 ,f6 u ($1):((column('C-NO_0'))*1E+00) notitle w l lt 1 lw lwnewG lc rgb 'blue'\
 ,f6 u ($1):((column('C-OH_0'))*1E+00) notitle w l lt 1 lw lwnewG lc rgb 'black'\

# ,f1 u 1:($2*1E+00) notitle w p ps 3 lw 3 pt 7 lc rgb 'blue'\
# ,f2 u 1:($2*1E+00) notitle w p ps 3 lw 3 pt 9 lc rgb 'black'\

unset key
unset multiplot
#-------------------------------------------------------------

