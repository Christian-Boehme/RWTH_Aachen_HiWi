#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#------------------------------------------------------------

set term postscript size fw,fh eps font "Times, 36" color
set out '../figures_postscripteps/IDT_C2H4_Peng_Set_5.eps'

set encoding utf8
set termoption enhanced

set xtics 0.0,0.05,2.0
#set ytics 0,0.003,3000
set mxtics 1
set mytics 5

set xlabel '1000/T [1/K]'
set ylabel '{/Symbol t}_{ign} [ms]' offset 0.25,0.0
set border lw 2
set xrange [0.65:0.95]
#set yrange [0.001:1000000]

set multiplot
set format x "%.2f"
set logscale y
set lmargin at screen 0.25
set rmargin at screen 0.95

# Experiments
f1 = '../ExperimentalData/IDT_C2H4_Peng_Set_5.txt'
# FM simulations
f4 = ARG1
f5 = ARG2

set label '{/Symbol f} = 2.0, p = 1 atm' at graph 0.03, graph 0.90

p f1 u 1:($2*1E+00):3:4 notitle w errorbars ps psize pt 7 lw plw lc rgb 'blue'\
 ,f4 u ($2):3 notitle w l lt 1 lw lwref lc rgb 'blue' dashtype 2\
 ,f5 u ($2):3 notitle w l lt 1 lw lwnew lc rgb 'blue'\

# ,f1 u 1:($2*1E+00):3:4 notitle w errorbars ps psize pt 7 lw plw lc rgb 'blue'\

unset key
unset multiplot

#-------------------------------------------------------------
