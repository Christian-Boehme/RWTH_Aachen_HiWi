#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#-------------------------------------------------------------

set term postscript size 5, 3.5 eps font "Times, 24" color
set out '../figures_postscripteps/Glarborg2018_N2O_NNH.eps'

set termoption enhanced
set encoding utf8

set mxtics 1
set mytics 1

#set title ''
set xlabel 'T [K]'
set ylabel 'X [ppm]'
set border lw 1
set xrange [1650:1730]
set yrange [0:50]
set xtics 1650,20,1750
set ytics 0,10,50

set multiplot

# Experiments
f1 = '../ExperimentalData/N2O_NNH/JSR_N2O.txt'
f2 = '../ExperimentalData/N2O_NNH/JSR_NO.txt'
#f3 = '../ExperimentalData/NH3/.txt'
# FM simulations
f4 = ARG1
f5 = ARG2
f6 = ARG3
f7 = ARG4
f8 = ARG5
f9 = ARG6

# old key position: 0.975, 0.50
set key at graph 0.20, graph 0.975 spacing 1.25 samplen -1.5
p f1 u 1:($2*1E+00) t 'N_2O x5' w p ps 3 lw 3 pt 7 lc rgb 'blue'\
 ,f2 u 1:($2*1E+00) t 'NO' w p ps 3 lw 3 pt 9 lc rgb 'black'\
 ,f4 u ($1):((column('X-N2O_0'))*1E+00) notitle w l lt 1 lw lwrefG lc rgb 'blue' dashtype 2\
 ,f5 u ($1):((column('X-NO_0'))*1E+00) notitle w l lt 1 lw lwrefG lc rgb 'black' dashtype 2\
 ,f6 u ($1):((column('X-N2O_0'))*1E+00) notitle w l lt 1 lw lwdetG lc rgb 'blue' dashtype 3\
 ,f7 u ($1):((column('X-NO_0'))*1E+00) notitle w l lt 1 lw lwdetG lc rgb 'black' dashtype 3\
 ,f8 u ($1):((column('X-N2O_0'))*1E+00) notitle w l lt 1 lw lwnewG lc rgb 'blue'\
 ,f9 u ($1):((column('X-NO_0'))*1E+00) notitle w l lt 1 lw lwnewG lc rgb 'black'\

# ,f1 u 1:($2*1E+00) notitle w p ps 3 lw 3 pt 7 lc rgb 'blue'\
# ,f2 u 1:($2*1E+00) notitle w p ps 3 lw 3 pt 9 lc rgb 'black'\

unset key
unset multiplot
#-------------------------------------------------------------

