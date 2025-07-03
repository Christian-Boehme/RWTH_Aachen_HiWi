#!/usr/bin/gnuplot -persist

set term postscript eps enhanced color font "Times, 32"
set out 'figures/DevRate_CoalWS_AIR20-DP125.eps'

#set xtics 0,40,240
set ytics 0,0.2E-4,1E-4
set mxtics 2
set mytics 1

set xtics mirror
set ytics mirror

set xlabel 't [ms]'
set ylabel '$\dot{m}_{vol+moisture} [kg/s]'
set border lw 2
set xrange [0:14]
set yrange [0:1E-4]

set multiplot

# simulation data
f1 = '~/p0021020/Pooria/SINGLES/COL/AIR20-DP125/monitor_TaoLi/coal'
f2 = '~/p0021020/Pooria/SINGLES/WS/AIR20-DP125/monitor_TaoLi/coal'

# ignition delay times
tign_coal = 8.30
tign_ws   = 7.40
set arrow from tign_coal, graph 0 to tign_coal, graph 1 nohead lw 4 lc rgb "#1f78b4" dashtype 2
set arrow from tign_ws, graph 0 to tign_ws, graph 1 nohead lw 4 lc rgb "#e31a1c" dashtype 2

set key at graph 0.35, graph 0.97 samplen 2
set key spacing 1.0
p f1 u ($2*1000):(column('rtotmax')*1E+03) t 'Coal' w l lw 4 lc rgb '#1f78b4'\
 ,f2 u ($2*1000):(column('rtotmax')*1E+03) t 'WS' w l lw 4 lc rgb '#e31a1c'\

unset key
unset multiplot

#-------------------------------------------------------------

