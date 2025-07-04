#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup_Glarborg2018.gnu'
#-------------------------------------------------------------

set term postscript size 5, 3.5 eps font "Times, 46" color
set out '../figures_postscripteps/Glarborg2018_NH3_Stoich.eps'

set termoption enhanced
set encoding utf8

set mxtics 1
set mytics 1

#set title ''
set xlabel 'T [K]'
set ylabel 'X [ppm]' offset 0.5,0.0
set border lw 1
set xrange [900:1900]
set yrange [0:600]
set xtics 900,250,1900
set ytics 0,150,600
set lmargin at screen 0.275
set rmargin at screen 0.925

set multiplot

# Experiments
f1 = '../ExperimentalData/NH3/FR_NO_Stoich.txt'
f2 = '../ExperimentalData/NH3/FR_NH3_Stoich.txt'
#f3 = '../ExperimentalData/NH3/.txt'
# FM simulations
f4 = ARG1
f5 = ARG2
f6 = ARG3

set label '{/Symbol f} = 1.07' at graph 0.03, graph 0.90

set key at graph 0.975, graph 0.97 spacing 1.1 samplen -1.5
p f1 u 1:($2*1E+00) t 'NO' w p ps 3 lw 3 pt 7 lc rgb 'blue'\
 ,f2 u 1:($2*1E+00) t 'NH_3' w p ps 3 lw 3 pt 9 lc rgb 'black'\
 ,f4 u ($1):((column('X-NO_0'))*1E+00) notitle w l lt 1 lw lwrefG lc rgb 'blue' dashtype 2\
 ,f4 u ($1):((column('X-NH3_0'))*1E+00) notitle w l lt 1 lw lwrefG lc rgb 'black' dashtype 2\
 ,f5 u ($1):((column('X-NO_0'))*1E+00) notitle w l lt 1 lw lwdetG lc rgb 'blue' dashtype 3\
 ,f5 u ($1):((column('X-NH3_0'))*1E+00) notitle w l lt 1 lw lwdetG lc rgb 'black' dashtype 3\
 ,f6 u ($1):((column('X-NO_0'))*1E+00) notitle w l lt 1 lw lwnewG lc rgb 'blue'\
 ,f6 u ($1):((column('X-NH3_0'))*1E+00) notitle w l lt 1 lw lwnewG lc rgb 'black'\

# ,f1 u 1:($2*1E+00) notitle w p ps 3 lw 3 pt 7 lc rgb 'blue'\
# ,f2 u 1:($2*1E+00) notitle w p ps 3 lw 3 pt 9 lc rgb 'black'\

unset key
unset multiplot
#-------------------------------------------------------------

