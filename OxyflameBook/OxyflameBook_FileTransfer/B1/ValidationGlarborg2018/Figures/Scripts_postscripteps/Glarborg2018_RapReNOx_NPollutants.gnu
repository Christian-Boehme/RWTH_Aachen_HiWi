#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#-------------------------------------------------------------

set term postscript size 5, 3.5 eps font "Times, 36" color
set out '../figures_postscripteps/Glarborg2018_RapReNOx_NPollutants.eps'

set termoption enhanced
set encoding utf8

set mxtics 1
set mytics 1

#set title ''
set xlabel 'T [K]'
set ylabel 'X [ppm]'
set border lw 1
set xrange [900:1400]
set yrange [0:1600]
set xtics 900,100,1400
set ytics 0,400,1600

set multiplot

# Experiments
f1 = '../ExperimentalData/RapReNOx/FR_HNCO.txt'
f2 = '../ExperimentalData/RapReNOx/FR_NO.txt'
f3 = '../ExperimentalData/RapReNOx/FR_N2O.txt'
# FM simulations
f4 = ARG1
f5 = ARG2
f6 = ARG3

set key at graph 0.975, graph 0.97 spacing 1.1 samplen -1.5
p f1 u 1:($2*1E+00) t 'HNCO' w p ps 3 lw 3 pt 7 lc rgb 'blue'\
 ,f2 u 1:($2*1E+00) t 'NO' w p ps 3 lw 3 pt 9 lc rgb 'red'\
 ,f3 u 1:($2*1E+00) t 'N_2O' w p ps 3 lw 3 pt 11 lc rgb 'black'\
 ,f4 u ($1):((column('X-HNCO_0'))*1E+00) notitle w l lt 1 lw lwrefG lc rgb 'blue' dashtype 2\
 ,f4 u ($1):((column('X-NO_0'))*1E+00) notitle w l lt 1 lw lwrefG lc rgb 'red' dashtype 2\
 ,f4 u ($1):((column('X-N2O_0'))*1E+00) notitle w l lt 1 lw lwrefG lc rgb 'black' dashtype 2\
 ,f5 u ($1):((column('X-HNCO_0'))*1E+00) notitle w l lt 1 lw lwdetG lc rgb 'blue' dashtype 3\
 ,f5 u ($1):((column('X-NO_0'))*1E+00) notitle w l lt 1 lw lwdetG lc rgb 'red' dashtype 3\
 ,f5 u ($1):((column('X-N2O_0'))*1E+00) notitle w l lt 1 lw lwdetG lc rgb 'black' dashtype 3\
 ,f6 u ($1):((column('X-HNCO_0'))*1E+00) notitle w l lt 1 lw lwnewG lc rgb 'blue'\
 ,f6 u ($1):((column('X-NO_0'))*1E+00) notitle w l lt 1 lw lwnewG lc rgb 'red'\
 ,f6 u ($1):((column('X-N2O_0'))*1E+00) notitle w l lt 1 lw lwnewG lc rgb 'black'\

# ,f1 u 1:($2*1E+00) notitle w p ps 3 lw 3 pt 7 lc rgb 'blue'\
# ,f2 u 1:($2*1E+00) notitle w p ps 3 lw 3 pt 9 lc rgb 'red'\
# ,f3 u 1:($2*1E+00) notitle w p ps 3 lw 3 pt 11 lc rgb 'black'\

unset key
unset multiplot
#-------------------------------------------------------------

