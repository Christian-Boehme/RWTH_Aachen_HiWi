#!/usr/bin/gnuplot -persist

set term pdfcairo enhanced font "Times, 22" color
set out 'figures/VolatileFlameTime_Coal_AIR20.eps'

#set encoding utf8

set xtics 0,40,240
set ytics 0,5,30
set mxtics 4
set mytics 5

set xtics mirror
set ytics mirror

set xlabel 'D_{par} [µm]'
set ylabel '{/Symbol t}_{vol} [ms]'
set border lw 2
set xrange [80:200]
set yrange [0:20]

set multiplot

# experimental data
f6 = '../../Data/Sim_tvol_Coal_AIR20.txt'

set key at graph 0.57, graph 0.97 samplen 3
set key spacing 1.0
p f6 u 1:2 t 'Simulation' w lp pt 9 ps 2 lw 4 lc rgb '#e31a1c'\


unset key
unset multiplot

#-------------------------------------------------------------

