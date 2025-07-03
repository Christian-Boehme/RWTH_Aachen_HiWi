#!/usr/bin/gnuplot -persist

set term pdfcairo enhanced font "Times, 22" color
set out 'figures/IgnitionDelayTime_WS_AIR20.eps'

#set encoding utf8

set xtics 0,20,240
set ytics 0,5,30
set mxtics 4
set mytics 5

set xtics mirror
set ytics mirror

set xlabel 'D_{p} [µm]'
set ylabel '{/Symbol t}_{ign} [ms]'
set border lw 2
set xrange [80:200]
set yrange [0:25]

set multiplot

# experimental data
f3 = '../../Data/IDT_TaoLi/AIR20_W1.csv'
f4 = '../../Data/IDT_TaoLi/AIR20_W2.csv'
f5 = '../../Data/IDT_TaoLi/AIR20_W3.csv'
f6 = '../../Data/Simulations/Sim_IDT_WS_AIR20.txt'

set label at graph 0.81, graph 0.925 '(b) WS'

set key at graph 0.60, graph 0.97 samplen 3
set key spacing 1.0
p f3 u 1:2 t 'Exp. <D_{p}>=127µm' w p pt 7 ps 1 lc rgb '#99ffa500'\
 ,f3 u 1:2 notitle w p pt 6 ps 1 lc rgb '#99ffa500'\
 ,f4 u 1:2 t 'Exp. <D_{p}>=152µm' w p pt 7 ps 1 lc rgb '#990d98ba'\
 ,f4 u 1:2 notitle w p pt 6 ps 1 lc rgb '#990d98ba'\
 ,f5 u 1:2 t 'Exp. <D_{p}>=182µm' w p pt 7 ps 1 lc rgb '#99800080'\
 ,f5 u 1:2 notitle w p pt 6 ps 1 lc rgb '#99800080'\
 ,f6 u 1:2 t 'Sim.' w lp pt 9 ps 2 lw 4 lc rgb '#e31a1c'\


unset key
unset multiplot

#-------------------------------------------------------------

