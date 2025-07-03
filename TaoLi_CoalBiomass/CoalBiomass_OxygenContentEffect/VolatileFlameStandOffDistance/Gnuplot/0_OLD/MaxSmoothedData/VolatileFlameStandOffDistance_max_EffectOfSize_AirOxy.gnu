#!/usr/bin/gnuplot -persist

set term postscript eps enhanced color font "Times, 32"
set out 'figures/VolatileFlameStandOffDistance_max_EffectOfSize_AirOxy.eps'

#set xtics 0,40,240
#set ytics 0,0.003,0.018
set mxtics 2
set mytics 2

set xtics mirror
set ytics mirror

set xlabel 'D_{par} [µm]'
set ylabel '(r_{f}-r_p)/r_p [-]'
set border lw 2
set xrange [75:175]
set yrange [2:10]

set multiplot

# simulation data
f1 = '../../Data/AverageData/Coal_AIR20_SizeEffect_max.txt'
f2 = '../../Data/AverageData/Coal_AIR20_SizeEffect_Oxy_max.txt'
f3 = '../../Data/AverageData/WS_AIR20_SizeEffect_max.txt'
f4 = '../../Data/AverageData/WS_AIR20_SizeEffect_Oxy_max.txt'

set key at graph 0.97, graph 0.97 samplen 3
set key spacing 1.0
p f1 u ($1):($2) t 'Coal: Air' w lp pt 9 ps 3 lw 4 lc rgb '#1f78b4' dashtype 2\
 ,f2 u ($1):($2) t 'Coal: Oxy' w lp pt 9 ps 3 lw 4 lc rgb '#1f78b4'\
 ,f3 u ($1):($2) t 'WS: Air' w lp pt 9 ps 3 lw 4 lc rgb '#e31a1c' dashtype 2\
 ,f4 u ($1):($2) t 'WS: Oxy' w lp pt 9 ps 3 lw 4 lc rgb '#e31a1c'\

unset key
unset multiplot

#-------------------------------------------------------------

