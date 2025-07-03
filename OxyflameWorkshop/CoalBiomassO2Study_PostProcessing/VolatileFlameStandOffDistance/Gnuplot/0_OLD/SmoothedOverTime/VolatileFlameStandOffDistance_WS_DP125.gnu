#!/usr/bin/gnuplot -persist

set term postscript eps enhanced color font "Times, 32"
set out 'figures/VolatileFlameStandOffDistance_WS_DP125.eps'

#set xtics 0,40,240
#set ytics 0,0.003,0.018
set mxtics 2
set mytics 2

set xtics mirror
set ytics mirror

set xlabel '{/Symbol D}t [ms]'
set ylabel '(r_{f}-r_p)/r_p [-]'
set border lw 2
set xrange [0:30]
set yrange [-1:10]

set multiplot

# simulation data
f1 = '../../Data/WS/AIR10-DP125/SmoothedData.txt'
f2 = '../../Data/WS/AIR20-DP125/SmoothedData.txt'
f3 = '../../Data/WS/AIR40-DP125/SmoothedData.txt'

set key at graph 0.97, graph 0.97
set key spacing 1.0
p f1 u ($1*1000-7.36):(column('rf_minus_rp')) t 'X_{O_2}=10%' w l lw 4 lc rgb '#1f78b4'\
 ,f2 u ($1*1000-7.40):(column('rf_minus_rp')) t 'X_{O_2}=20%' w l lw 4 lc rgb '#33a02c'\
 ,f3 u ($1*1000-7.62):(column('rf_minus_rp')) t 'X_{O_2}=40%' w l lw 4 lc rgb '#e31a1c'\

unset key
unset multiplot

#-------------------------------------------------------------

