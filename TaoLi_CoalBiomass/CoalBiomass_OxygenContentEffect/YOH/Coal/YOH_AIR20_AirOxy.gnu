#!/usr/bin/gnuplot -persist

set term postscript eps enhanced color font "Times, 32"
set out 'figures/YOH_Coal_AIR20_AirOxy.eps'

#set xtics 0,40,240
set ytics 0,0.004,0.02
set mxtics 2
set mytics 2

set xtics mirror
set ytics mirror

set xlabel 't [ms]'
set ylabel 'Y_{OH} [-]'
set border lw 2
set xrange [0:100]
set yrange [0:0.02]

set multiplot

# simulation data
f1 = '~/p0021020/Pooria/SINGLES/COL/AIR20-DP90/monitor_TaoLi/scalar'
f2 = '~/p0021020/Pooria/SINGLES/COL/OXY20-DP90/monitor_TaoLi/scalar'
f3 = '~/p0021020/Pooria/SINGLES/COL/AIR20-DP125/monitor_TaoLi/scalar'
f4 = '~/p0021020/Pooria/SINGLES/COL/OXY20-DP125/monitor_TaoLi/scalar'
f5 = '~/p0021020/Pooria/SINGLES/COL/AIR20-DP160/monitor_TaoLi/scalar'
f6 = '~/p0021020/Pooria/SINGLES/COL/OXY20-DP160/monitor_TaoLi/scalar'

set key at graph 0.97, graph 0.97 samplen 3
set key spacing 1.0
p f1 u ($2*1000):(column('max_OH')) t 'AIR90' w l lw 4 lc rgb '#1f78b4' dashtype 2\
 ,f2 u ($2*1000):(column('max_OH')) t 'OXY90' w l lw 4 lc rgb '#1f78b4'\
 ,f3 u ($2*1000):(column('max_OH')) t 'AIR125' w l lw 4 lc rgb '#33a02c' dashtype 2\
 ,f4 u ($2*1000):(column('max_OH')) t 'OXY125' w l lw 4 lc rgb '#33a02c'\
 ,f5 u ($2*1000):(column('max_OH')) t 'AIR160' w l lw 4 lc rgb '#e31a1c' dashtype 2\
 ,f6 u ($2*1000):(column('max_OH')) t 'OXY160' w l lw 4 lc rgb '#e31a1c'\

unset key
unset multiplot

#-------------------------------------------------------------

