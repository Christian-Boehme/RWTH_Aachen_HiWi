#!/usr/bin/gnuplot -persist

set term pdfcairo enhanced font "Times, 22"
set out 'figures/VolatileFlameTime_AIR20.eps'

set xtics 0,10,240
set ytics 0,5,30
set mxtics 2
set mytics 5

set xtics mirror
set ytics mirror

set xlabel 'D_{par} [µm]'
set ylabel '{/Symbol t}_{vol} [ms]'
set border lw 2
set xrange [75:175]
set yrange [0:25]

set multiplot

# simulation data
f1 = '../../Data/Sim_tvol_Coal_AIR20.txt'
f2 = '../../Data/Sim_tvol_WS_AIR20.txt'

set key at graph 0.30, graph 0.97 samplen 3
set key spacing 1.0
p f1 u 1:2 t 'Coal' w lp pt 9 ps 2 lw 4 lc rgb '#1f78b4'\
 ,f2 u 1:2 t 'WS' w lp pt 9 ps 2 lw 4 lc rgb '#e31a1c'\

unset key
unset multiplot

#-------------------------------------------------------------

