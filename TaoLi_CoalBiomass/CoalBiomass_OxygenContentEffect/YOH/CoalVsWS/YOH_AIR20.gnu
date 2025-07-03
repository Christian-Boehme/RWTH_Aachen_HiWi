#!/usr/bin/gnuplot -persist

set term postscript eps enhanced color font "Times, 32"
set out 'figures/YOH_AIR20.eps'

#set xtics 0,40,240
#set ytics 0,0.003,0.018
#set mxtics 4
set mytics 1

set xtics mirror
set ytics mirror

set xlabel 't [ms]'
set ylabel 'Y_{OH} [-]'
set border lw 2
set xrange [0:100]
#set yrange [0:20]

set multiplot

# simulation data
f1 = '~/p0021020/Pooria/SINGLES/COL/AIR20-DP90/monitor_TaoLi/scalar'
f2 = '~/p0021020/Pooria/SINGLES/COL/AIR20-DP125/monitor_TaoLi/scalar'
f3 = '~/p0021020/Pooria/SINGLES/COL/AIR20-DP160/monitor_TaoLi/scalar'
f4 = '~/p0021020/Pooria/SINGLES/WS/AIR20-DP90/monitor_TaoLi/scalar'
f5 = '~/p0021020/Pooria/SINGLES/WS/AIR20-DP125/monitor_TaoLi/scalar'
f6 = '~/p0021020/Pooria/SINGLES/WS/AIR20-DP160/monitor_TaoLi/scalar'

set key at graph 0.99, graph 0.97 samplen 2
set key spacing 1.0
p f1 u ($2*1000):(column('max_OH')) t 'D_{par}= 90µm' w l lw 4 lc rgb '#1f78b4' dashtype 2\
 ,f2 u ($2*1000):(column('max_OH')) t 'D_{par}=125µm' w l lw 4 lc rgb '#33a02c' dashtype 2\
 ,f3 u ($2*1000):(column('max_OH')) t 'D_{par}=160µm' w l lw 4 lc rgb '#e31a1c' dashtype 2\
 ,f4 u ($2*1000):(column('max_OH')) t 'D_{par}= 90µm' w l lw 4 lc rgb '#1f78b4'\
 ,f5 u ($2*1000):(column('max_OH')) t 'D_{par}=125µm' w l lw 4 lc rgb '#33a02c'\
 ,f6 u ($2*1000):(column('max_OH')) t 'D_{par}=160µm' w l lw 4 lc rgb '#e31a1c'\

unset key
unset multiplot

#-------------------------------------------------------------

