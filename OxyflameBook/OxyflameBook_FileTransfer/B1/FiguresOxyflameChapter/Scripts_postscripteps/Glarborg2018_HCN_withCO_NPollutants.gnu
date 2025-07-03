#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup_Glarborg2018.gnu'
#-------------------------------------------------------------

set term postscript size 5, 3.5 eps font "Times, 42" color
set out '../figures_postscripteps/Glarborg2018_HCN_withCO_NPollutants.eps'

set termoption enhanced
set encoding utf8

set mxtics 1
set mytics 1

#set title ''
#set xlabel 'T [K]'
set ylabel 'X [ppm]'
set border lw 1
set xrange [900:1400]
set yrange [0:400]
set xtics 900,100,1500
set ytics 0,100,400
set lmargin at screen 0.275
set rmargin at screen 0.925
set bmargin at screen 0.250

set multiplot

# Experiments
f1 = '../ExperimentalData/HCN/HCN_CO10_HCNFR.txt'
f2 = '../ExperimentalData/HCN/HCN_CO10_NOFR.txt'
f3 = '../ExperimentalData/HCN/HCN_CO10_N2OFR.txt'
# FM simulations
f4 = ARG1
f5 = ARG2
f6 = ARG3

set key at graph 0.98, graph 0.97 spacing 1.0 samplen -1.5
p f1 u 1:($2*1E+00) t 'HCN' w p ps 3 lw 3 pt 7 lc rgb 'blue'\
 ,f2 u 1:($2*1E+00) t 'NO' w p ps 3 lw 3 pt 9 lc rgb 'black'\
 ,f3 u 1:($2*1E+00) t 'N_2O' w p ps 3 lw 3 pt 11 lc rgb 'red'\
 ,f4 u ($1):((column('X-HCN_0'))*1E+00) notitle w l lt 1 lw lwrefG lc rgb 'blue' dashtype 2\
 ,f4 u ($1):((column('X-NO_0'))*1E+00) notitle w l lt 1 lw lwrefG lc rgb 'black' dashtype 2\
 ,f4 u ($1):((column('X-N2O_0'))*1E+00) notitle w l lt 1 lw lwrefG lc rgb 'red' dashtype 2\
 ,f5 u ($1):((column('X-HCN_0'))*1E+00) notitle w l lt 1 lw lwdetG lc rgb 'blue' dashtype 3\
 ,f5 u ($1):((column('X-NO_0'))*1E+00) notitle w l lt 1 lw lwdetG lc rgb 'black' dashtype 3\
 ,f5 u ($1):((column('X-N2O_0'))*1E+00) notitle w l lt 1 lw lwdetG lc rgb 'red' dashtype 3\
 ,f6 u ($1):((column('X-HCN_0'))*1E+00) notitle w l lt 1 lw lwnewG lc rgb 'blue'\
 ,f6 u ($1):((column('X-NO_0'))*1E+00) notitle w l lt 1 lw lwnewG lc rgb 'black'\
 ,f6 u ($1):((column('X-N2O_0'))*1E+00) notitle w l lt 1 lw lwnewG lc rgb 'red'\

# ,f1 u 1:($2*1E+00) notitle w p ps 3 lw 3 pt 7 lc rgb 'blue'\
# ,f2 u 1:($2*1E+00) notitle w p ps 3 lw 3 pt 9 lc rgb 'black'\
# ,f3 u 1:($2*1E+00) notitle w p ps 3 lw 3 pt 11 lc rgb 'red'\

unset key
unset multiplot
#-------------------------------------------------------------

