#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup_IDTPropyon.gnu'
#-------------------------------------------------------------

set term postscript size fw,fh eps font "Times, 46" color
set out '../figures_postscripteps/IDT_Propanal_Rich.eps'

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
set yrange [0.001:100]

# Fix the margins to ensure consistent box size
set lmargin at screen 0.3250
set rmargin at screen 0.9325

set multiplot
set logscale y

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
p f00 u ($1/10):2:3:4 notitle w errorbars pt 5 ps psize lw plw lc rgb 'blue'\
 ,f1 u ($2):3 notitle w l lt 1 lw lwrefO lc rgb 'blue' dashtype 2\
 ,f2 u ($2):3 notitle w l lt 1 lw lwrefO lc rgb 'black' dashtype 2\
 ,f3 u ($2):3 notitle w l lt 1 lw lwdetO lc rgb 'blue' dashtype 3\
 ,f4 u ($2):3 notitle w l lt 1 lw lwdetO lc rgb 'black' dashtype 3\
 ,f5 u ($2):3 notitle w l lt 1 lw lwnewO lc rgb 'blue'\
 ,f6 u ($2):3 notitle w l lt 1 lw lwnewO lc rgb 'black'\

# ,f00 u ($1/10):2:3:4 notitle w errorbars pt 5 ps psize lw plw lc rgb 'blue'\


unset key
unset multiplot

#-------------------------------------------------------------
