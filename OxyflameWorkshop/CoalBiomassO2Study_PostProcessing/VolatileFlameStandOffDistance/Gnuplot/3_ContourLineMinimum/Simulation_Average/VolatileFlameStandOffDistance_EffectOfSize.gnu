#!/usr/bin/gnuplot -persist

set term postscript eps enhanced color font "Times, 32"
set out 'figures/VolatileFlameStandOffDistance_EffectOfSize.eps'

#set xtics 0,40,240
#set ytics 0,0.003,0.018
set mxtics 2
set mytics 2

set xtics mirror
set ytics mirror

set xlabel 'D_{par} [µm]'
set ylabel 'r_{f}/r_p [-]'
set border lw 2
set xrange [75:175]
set yrange [0:8]

set multiplot

# simulation data
f1 = '../../../Data/3_ContourLineMinimum/Sim_Coal_EffectOfSize_Air_sim_avg.csv'
f2 = '../../../Data/3_ContourLineMinimum/Sim_WS_EffectOfSize_Air_sim_avg.csv'

set key at graph 0.97, graph 0.97 samplen 3
set key spacing 1.0
p f1 u ($1):($2) t 'Coal' w lp pt 9 ps 3 lw 4 lc rgb '#1f78b4'\
 ,f2 u ($1):($2) t 'WS' w lp pt 9 ps 3 lw 4 lc rgb '#e31a1c'\

unset key
unset multiplot

#-------------------------------------------------------------

