#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#------------------------------------------------------------

set term postscript size fw,fh eps font "Times, 42" color
set out '../figures_postscripteps/B1b_LCai_IDT_CH4_Koroglu_Stoi.eps'

set encoding utf8
set termoption enhanced

set xtics 0.0,0.05,2.0
#set ytics 0,0.003,3000
set mxtics 2
set mytics 5

set xlabel '1000/T [1/K]'
set ylabel '{/Symbol t}_{ign} [ms]' offset 0.5,0
set border lw 2
set xrange [0.475:0.625]
#set yrange [0.001:1000000]

set multiplot
set format x "%.2f"
set logscale y
set lmargin at screen 0.30
set rmargin at screen 0.975

# Experiments
f1 = '../ExperimentalData/Koroglu_Stoi_LP.txt'
f2 = '../ExperimentalData/Koroglu_Stoi_HP.txt'
# FM simulations
f4 = ARG1
f5 = ARG2

set label '{/Symbol f} = 1.0' at graph 0.03, graph 0.90

set key at graph 1.025, graph 0.275 spacing 1.0 samplen 0.5
p f1 u 1:($2*1E+00) t '0.76 atm' w p ps 3 pt 7 lw 3 lc rgb '#1f78b4'\
 ,f2 u 1:($2*1E+00) t '3.77 atm' w p ps 3 pt 9 lw 3 lc rgb '#e31a1c'\
 ,f4 u ($2):3 notitle w l lt 1 lw 6 lc rgb '#1f78b4'\
 ,f5 u ($2):3 notitle w l lt 1 lw 6 lc rgb '#e31a1c'\
 ,f1 u 1:($2*1E+00) notitle w p ps 3 pt 7 lw 3 lc rgb '#1f78b4'\
 ,f2 u 1:($2*1E+00) notitle w p ps 3 pt 9 lw 3 lc rgb '#e31a1c'\

unset key
unset multiplot

#-------------------------------------------------------------
