#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#-------------------------------------------------------------

set term epslatex standalone color size fh,fw font "Times, 20"
set out '../figures_epslatex/IDT_Propanal_Rich.tex'

set encoding utf8
set termoption enhanced

set xtics 0,0.1,10
#set ytics 0,0.01,3000
set mxtics 1
set mytics 5

#set title ''
set xlabel '$\mathrm{1000/T [K\textsuperscript{-1}]}$'
set ylabel '$\tau_\mathrm{ign}$ [ms]' offset 1.0,0
set border lw 2
set xrange [0.55:1.00]
#set yrange [0.001:1000000]

# Fix margins to ensure consistent box size
set lmargin at screen 0.225
set rmargin at screen 0.950
set tmargin at screen 0.925
set bmargin at screen 0.225

set multiplot
set logscale y

# Experimental data
f00 = '../ExperimentalData/Pelucchi_Propanal_1atm_exp_phi2.txt'
# FM simulations
f1 = ARG1
f2 = ARG2
f3 = ARG3
f4 = ARG4
f5 = ARG5
f6 = ARG6

set label '$\phi$ = 2.0' at graph 0.03, graph 0.90

# Create figure
p f00 u ($1/10):2:3:4 notitle w errorbars pt 5 ps psize lw plw lc rgb 'blue'\
 ,f1 u ($2):3 notitle w l lt 1 lw lwrefI lc rgb 'blue' dashtype 2\
 ,f2 u ($2):3 notitle w l lt 1 lw lwrefI lc rgb 'black' dashtype 2\
 ,f3 u ($2):3 notitle w l lt 1 lw lwdetI lc rgb 'blue' dashtype 3\
 ,f4 u ($2):3 notitle w l lt 1 lw lwdetI lc rgb 'black' dashtype 3\
 ,f5 u ($2):3 notitle w l lt 1 lw lwnewI lc rgb 'blue'\
 ,f6 u ($2):3 notitle w l lt 1 lw lwnewI lc rgb 'black'\

# ,f00 u ($1/10):2:3:4 notitle w errorbars pt 5 ps psize lw plw lc rgb 'blue'\


unset key
unset multiplot

#-------------------------------------------------------------
