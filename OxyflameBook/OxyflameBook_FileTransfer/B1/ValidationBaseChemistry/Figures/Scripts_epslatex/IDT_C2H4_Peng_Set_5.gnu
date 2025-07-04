#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#-------------------------------------------------------------

set term epslatex standalone color size fh,fw font "Times, 17"
set out '../figures_epslatex/IDT_C2H4_Peng_Set_5.tex'

set encoding utf8
set termoption enhanced

set xtics 0.0,0.05,2.0
#set ytics 0,0.003,3000
set mxtics 1
set mytics 5

#set title ''
set xlabel '$\mathrm{1000/T [K\textsuperscript{-1}]}$'
set ylabel '$\tau_\mathrm{ign}$ [ms]' offset 1.0,0.0
set border lw 2
set xrange [0.65:0.95]
#set yrange [0.001:1000000]

set multiplot
set format x "%.2f"
set logscale y

# Experiments
f1 = '../ExperimentalData/IDT_C2H4_Peng_Set_5.txt'
# FM simulations
f4 = ARG1
f5 = ARG2

set label '$\mathrm{\phi}$ = 2.0, p = 1 atm' at graph 0.03, graph 0.90

p f1 u 1:($2*1E+00):3:4 notitle w p ps psize pt 7 lw plw lc rgb 'blue'\
 ,f4 u ($2):3 notitle w l lt 1 lw lwref lc rgb 'blue' dashtype 6\
 ,f5 u ($2):3 notitle w l lt 1 lw lwnew lc rgb 'blue'\

# ,f1 u 1:($2*1E+00):3:4 notitle w errorbars ps psize pt 7 lw plw lc rgb 'blue'\

unset key
unset multiplot

#-------------------------------------------------------------
