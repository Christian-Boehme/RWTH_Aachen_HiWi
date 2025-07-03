#!/usr/bin/gnuplot -persist

set term postscript eps enhanced color font "Times, 32"
set out 'figures/FlameThickness_AIR20_DP125_AirOxy.eps'

#set xtics 0,40,240
#set ytics 0,0.003,0.018
set mxtics 2
set mytics 2

set xtics mirror
set ytics mirror

set xlabel '{/Symbol D}t [ms]'
set ylabel '(l_{f}-r_p)/r_p [-]'
set border lw 2
set xrange [0:40]
#set yrange [-1:10]

set multiplot

# simulation data
f1 = '../../Data/Coal/AIR20-DP125/SmoothedData.txt'
f2 = '../../Data/Coal/OXY20-DP125/SmoothedData.txt'
f3 = '../../Data/WS/AIR20-DP125/SmoothedData.txt'
f4 = '../../Data/WS/OXY20-DP125/SmoothedData.txt'

set key at graph 0.97, graph 0.97 samplen 3
set key spacing 1.0
p f1 u ($1*1000-8.30):(column('tmin_flame')):(column('tmax_flame')) notitle w filledcurves lc rgb '#501f78b4' fs transparent solid 0.2\
 ,f2 u ($1*1000-7.90):(column('tmin_flame')):(column('tmax_flame')) notitle w filledcurves lc rgb '#751f78b4' fs transparent solid 0.2\
 ,f3 u ($1*1000-7.40):(column('tmin_flame')):(column('tmax_flame')) notitle w filledcurves lc rgb '#50e31a1c' fs transparent solid 0.2\
 ,f4 u ($1*1000-7.00):(column('tmin_flame')):(column('tmax_flame')) notitle w filledcurves lc rgb '#75e31a1c' fs transparent solid 0.2\
 ,f1 u ($1*1000-8.30):(column('tmid_flame')) t 'Coal: Air' w l lw 4 lc rgb '#1f78b4' dashtype 2\
 ,f2 u ($1*1000-7.90):(column('tmid_flame')) t 'Coal: Oxy' w l lw 4 lc rgb '#1f78b4'\
 ,f3 u ($1*1000-7.40):(column('tmid_flame')) t 'WS: Air' w l lw 4 lc rgb '#e31a1c' dashtype 2\
 ,f4 u ($1*1000-7.00):(column('tmid_flame')) t 'WS: Oxy' w l lw 4 lc rgb '#e31a1c'\

unset key
unset multiplot

#-------------------------------------------------------------

