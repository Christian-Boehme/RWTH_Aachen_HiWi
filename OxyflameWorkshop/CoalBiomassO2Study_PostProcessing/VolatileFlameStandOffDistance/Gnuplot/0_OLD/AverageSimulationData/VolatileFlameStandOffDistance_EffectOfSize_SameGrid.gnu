#!/usr/bin/gnuplot -persist

set term postscript eps enhanced color font "Times, 32"
set out 'figures/VolatileFlameStandOffDistance_EffectOfSize_SameGrid.eps'

#set xtics 0,40,240
#set ytics 0,0.003,0.018
set mxtics 2
set mytics 1

set xtics mirror
set ytics mirror

set xlabel 'D_{par} [µm]'
set ylabel '(r_{f}-r_p)/r_p [-]'
set border lw 2
set xrange [75:175]
#set yrange [0:5]

set multiplot

# simulation data
f1 = '../../Data/AverageData/Coal_AIR20_SizeEffect.txt'
f2 = '../../Data/AverageData/WS_AIR20_SizeEffect.txt'

set key at graph 0.97, graph 0.97 samplen 3
set key spacing 1.0
p f1 u ($1):($2) t 'Coal: D_{par}' w lp pt 9 ps 3 lw 4 lc rgb '#1f78b4' dashtype 2\
 ,f1 u ($1):($3) t 'Coal: 125µm' w lp pt 9 ps 3 lw 4 lc rgb '#1f78b4'\
 ,f2 u ($1):($2) t 'WS: D_{par}' w lp pt 9 ps 3 lw 4 lc rgb '#e31a1c' dashtype 2\
 ,f2 u ($1):($3) t 'WS: 125µm' w lp pt 9 ps 3 lw 4 lc rgb '#e31a1c'\

unset key
unset multiplot

#-------------------------------------------------------------

