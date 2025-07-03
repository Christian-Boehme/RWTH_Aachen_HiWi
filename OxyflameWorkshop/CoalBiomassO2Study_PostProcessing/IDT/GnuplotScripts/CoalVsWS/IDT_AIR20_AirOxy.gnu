#!/usr/bin/gnuplot -persist

set term pdfcairo enhanced font "Times, 20"
set out 'figures/IgnitionDelayTime_AIR20_AirOxy.eps'

set xtics 0,10,240
set ytics 0,5,30
set mxtics 2
set mytics 5

set xtics mirror
set ytics mirror

set xlabel 'D_{par} [µm]'
set ylabel '{/Symbol t}_{ign} [ms]'
set border lw 2
set xrange [75:175]
set yrange [0:25]

set multiplot

# simulation data
f1 = '../../Data/Simulations/Sim_IDT_Coal_AIR20.txt'
f2 = '../../Data/Simulations/Sim_IDT_Coal_AIR20_Oxy.txt'
f3 = '../../Data/Simulations/Sim_IDT_WS_AIR20.txt'
f4 = '../../Data/Simulations/Sim_IDT_WS_AIR20_Oxy.txt'

set key at graph 0.40, graph 0.97 samplen 3
set key spacing 1.0
p f1 u 1:2 t 'Coal: Air' w lp pt 9 ps 2 lw 4 lc rgb '#1f78b4' dashtype 2\
 ,f2 u 1:2 t 'Coal: Oxy' w lp pt 9 ps 2 lw 4 lc rgb '#1f78b4'\
 ,f3 u 1:2 t 'WS: Air' w lp pt 9 ps 2 lw 4 lc rgb '#e31a1c' dashtype 2\
 ,f4 u 1:2 t 'WS: Oxy' w lp pt 9 ps 2 lw 4 lc rgb '#e31a1c'\

unset key
unset multiplot

#-------------------------------------------------------------

