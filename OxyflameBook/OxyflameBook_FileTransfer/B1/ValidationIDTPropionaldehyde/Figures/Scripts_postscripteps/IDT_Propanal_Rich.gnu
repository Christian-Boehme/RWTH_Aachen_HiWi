#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#-------------------------------------------------------------

set term postscript eps size 5.0, 3.5 font "Times, 46" color
set out '../figures_postscripteps/B1b_Bio_IDT_Propanal_Rich.eps'

set encoding utf8
set termoption enhanced

set xtics 0,0.1,10
#set ytics 0,0.01,3000
set mxtics 1
set mytics 5

#set title ''
set xlabel '1000/T [1/K]'
set ylabel '{/Symbol t}_{ign} [ms]' offset 1.0,0.0
set border lw 2
set xrange [0.55:1.00]
#set yrange [0.001:1000000]

set multiplot
set logscale y
set lmargin at screen 0.30
set rmargin at screen 0.95

f00 = '../ExperimentalData/Pelucchi_Propanal_1atm_exp_phi2.txt'
# FM simulations
f1 = ARG1
f2 = ARG2
f3 = ARG3
f4 = ARG4
f5 = ARG5
f6 = ARG6

set label '{/Symbol f} = 2.0' at graph 0.03, graph 0.90

# Create figure
p f00 u ($1/10):2:3:4 notitle w errorbars pt 9 ps psize lw plw lc rgb '#1f78b4'\
 ,f1 u ($2):3 notitle w l lt 1 lw lwrefI lc rgb '#1f78b4' dashtype 2\
 ,f2 u ($2):3 notitle w l lt 1 lw lwrefI lc rgb '#e31a1c' dashtype 2\
 ,f3 u ($2):3 notitle w l lt 1 lw lwdetI lc rgb '#1f78b4' dashtype 3\
 ,f4 u ($2):3 notitle w l lt 1 lw lwdetI lc rgb '#e31a1c' dashtype 3\
 ,f5 u ($2):3 notitle w l lt 1 lw lwnewI lc rgb '#1f78b4'\
 ,f6 u ($2):3 notitle w l lt 1 lw lwnewI lc rgb '#e31a1c'\

# ,f00 u ($1/10):2:3:4 notitle w errorbars pt 9 ps psize lw plw lc rgb '#1f78b4'\

unset key
unset multiplot

#-------------------------------------------------------------
