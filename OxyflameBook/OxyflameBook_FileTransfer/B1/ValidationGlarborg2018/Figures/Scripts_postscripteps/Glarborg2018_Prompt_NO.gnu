#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#-------------------------------------------------------------

set term postscript size 5, 3.5 eps font "Times, 36" color
set out '../figures_postscripteps/Glarborg2018_Prompt_NO.eps'

set termoption enhanced
set encoding utf8

set mxtics 1
set mytics 1

#set title ''
set xlabel 'Height [cm]'
set ylabel 'X_{NO} [ppm]'
set border lw 1
set xrange [0:2.0]
set yrange [0:40]
set xtics 0,0.5,2.0
set ytics 0,10,40

set multiplot

# Experiments
f1 = '../ExperimentalData/Prompt/NOLean.txt'
f2 = '../ExperimentalData/Prompt/NOStoch.txt'
f3 = '../ExperimentalData/Prompt/NORich.txt'
# FM simulations
f4 = ARG1
f5 = ARG2
f6 = ARG3
f7 = ARG4
f8 = ARG5
f9 = ARG6

# Create figure
p f1 u 1:($2*1E+00) notitle w p ps 3 lw 3 pt 7 lc rgb 'blue'\
 ,f2 u 1:($2*1E+00) notitle w p ps 3 lw 3 pt 9 lc rgb 'black'\
 ,f3 u 1:($2*1E+00) notitle w p ps 3 lw 3 pt 11 lc rgb 'red'\
 ,f4 u ((column('x[cm]_0'))*1E+00):((column('X-NO_0'))*1E+00) notitle w l lt 1 lw lwrefG lc rgb 'blue' dashtype 2\
 ,f4 u ((column('x[cm]_1'))*1E+00):((column('X-NO_1'))*1E+00) notitle w l lt 1 lw lwrefG lc rgb 'black' dashtype 2\
 ,f5 u ((column('x[cm]_2'))*1E+00):((column('X-NO_2'))*1E+00) notitle w l lt 1 lw lwrefG lc rgb 'red' dashtype 2\
 ,f6 u ((column('x[cm]_0'))*1E+00):((column('X-NO_0'))*1E+00) notitle w l lt 1 lw lwdetG lc rgb 'blue' dashtype 3\
 ,f6 u ((column('x[cm]_1'))*1E+00):((column('X-NO_1'))*1E+00) notitle w l lt 1 lw lwdetG lc rgb 'black' dashtype 3\
 ,f7 u ((column('x[cm]_2'))*1E+00):((column('X-NO_2'))*1E+00) notitle w l lt 1 lw lwdetG lc rgb 'red' dashtype 3\
 ,f8 u ((column('x[cm]_0'))*1E+00):((column('X-NO_0'))*1E+00) notitle w l lt 1 lw lwnewG lc rgb 'blue'\
 ,f8 u ((column('x[cm]_1'))*1E+00):((column('X-NO_1'))*1E+00) notitle w l lt 1 lw lwnewG lc rgb 'black'\
 ,f9 u ((column('x[cm]_2'))*1E+00):((column('X-NO_2'))*1E+00) notitle w l lt 1 lw lwnewG lc rgb 'red'\

# ,f1 u 1:($2*1E+00) notitle w p ps 3 lw 3 pt 7 lc rgb 'blue'\
# ,f2 u 1:($2*1E+00) notitle w p ps 3 lw 3 pt 9 lc rgb 'black'\
# ,f3 u 1:($2*1E+00) notitle w p ps 3 lw 3 pt 11 lc rgb 'red'\

unset key
unset multiplot
#-------------------------------------------------------------

