#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup_IDTBaseChem.gnu'
#------------------------------------------------------------

set term postscript size fw,fh eps font "Times, 36" color
set out '../figures_postscripteps/IDT_CH4_Koroglu_Lean.eps'

set encoding utf8
set termoption enhanced

set xtics 0.0,0.05,2.0
#set ytics 0,0.003,3000
set mxtics 1
set mytics 5

set xlabel '1000/T [1/K]'
set ylabel '{/Symbol t}_{ign} [ms]' offset 0.25,0.0
set border lw 2
set xrange [0.50:0.65]
#set yrange [0.001:1000000]

set multiplot
set format x "%.2f"
set logscale y
set lmargin at screen 0.25
set rmargin at screen 0.95

# Experiments
f1 = '../ExperimentalData/Koroglu_Lean_LP.txt'
f2 = '../ExperimentalData/Koroglu_Lean_HP.txt'
# FM simulations
f4 = ARG1
f5 = ARG2
f6 = ARG3
f7 = ARG4

set label '{/Symbol f} = 0.5' at graph 0.03, graph 0.90

set key at graph 0.975, graph 0.25 spacing 1.1 samplen -1.5
p f1 u 1:($2*1E+00) t '0.77 atm' w p ps psize pt 7 lw plw lc rgb 'blue'\
 ,f2 u 1:($2*1E+00) t '3.92 atm' w p ps psize pt 9 lw plw lc rgb 'black'\
 ,f4 u ($2):3 notitle w l lt 1 lw lwref lc rgb 'blue' dashtype 2\
 ,f5 u ($2):3 notitle w l lt 1 lw lwref lc rgb 'black' dashtype 2\
 ,f6 u ($2):3 notitle w l lt 1 lw lwnew lc rgb 'blue'\
 ,f7 u ($2):3 notitle w l lt 1 lw lwnew lc rgb 'black'\

# ,f1 u 1:($2*1E+00) notitle w p ps psize pt 7 lw plw lc rgb 'blue'\
# ,f2 u 1:($2*1E+00) notitle w p ps psize pt 9 lw plw lc rgb 'black'\

unset key
unset multiplot

#-------------------------------------------------------------
