#!/usr/bin/gnuplot -persist

set term postscript eps enhanced color font "Times, 32"
set out 'figures/YOH_Coal_Dpar125.eps'

#set xtics 0,40,240
#set ytics 0,0.003,0.018
set mxtics 2
set mytics 2

set xtics mirror
set ytics mirror

set xlabel 't [ms]'
set ylabel 'Y_{OH} [-]'
set border lw 2
#set xrange [80:200]
#set yrange [0:20]

set multiplot

# simulation data
f1 = '~/p0021020/Pooria/SINGLES/COL/AIR10-DP125/monitor_TaoLi/scalar'
f2 = '~/p0021020/Pooria/SINGLES/COL/AIR20-DP125/monitor_TaoLi/scalar'
f3 = '~/p0021020/Pooria/SINGLES/COL/AIR40-DP125/monitor_TaoLi/scalar'

set key at graph 0.97, graph 0.97 samplen 3
set key spacing 1.0
p f1 u ($2*1000):(column('max_OH')) t 'X_{O_2}=10%' w l lw 4 lc rgb '#1f78b4'\
 ,f2 u ($2*1000):(column('max_OH')) t 'X_{O_2}=20%' w l lw 4 lc rgb '#33a02c'\
 ,f3 u ($2*1000):(column('max_OH')) t 'X_{O_2}=40%' w l lw 4 lc rgb '#e31a1c'\

unset key
unset multiplot

#-------------------------------------------------------------

