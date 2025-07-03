#!/usr/bin/gnuplot -persist

set term postscript eps enhanced color font "Times, 32"
set out 'figures/VolatileFlameStandOffDistance_WS_AIR20.eps'

#set xtics 0,40,240
#set ytics 0,0.003,0.018
set mxtics 2
set mytics 2

set xtics mirror
set ytics mirror

set xlabel '{/Symbol D}t [ms]'
set ylabel '(r_{f}-r_p)/r_p [-]'
set border lw 2
set xrange [0:40]
set yrange [-1:10]

set multiplot

# simulation data
f1 = '../../Data/WS/AIR20-DP90/SmoothedData.txt'
f2 = '../../Data/WS/AIR20-DP125/SmoothedData.txt'
f3 = '../../Data/WS/AIR20-DP160/SmoothedData.txt'

set key at graph 0.97, graph 0.97 samplen 3
set key spacing 1.0
p f1 u ($1*1000-4.20):(column('rf_minus_rp')) t '90µm' w l lw 4 lc rgb '#1f78b4'\
 ,f2 u ($1*1000-7.40):(column('rf_minus_rp')) t '125µm' w l lw 4 lc rgb '#33a02c'\
 ,f3 u ($1*1000-11.1):(column('rf_minus_rp')) t '160µm' w l lw 4 lc rgb '#e31a1c'\

unset key
unset multiplot

#-------------------------------------------------------------

