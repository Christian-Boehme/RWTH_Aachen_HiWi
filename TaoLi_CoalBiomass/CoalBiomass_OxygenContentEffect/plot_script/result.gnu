#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Global settings
#-------------------------------------------------------------
load 'def.gnu'
load 'palette.gnu'
load 'const.gnu'
#-------------------------------------------------------------


#-------------------------------------------------------------
set term epslatex standalone color size 5,5 dashlength 0.7
set out 'result.tex'

set xtics 50,20,130
set ytics 0,10,50
set mxtics 4
set mytics 2

##set title 'A(1-7) with different porosities'
set xlabel '$time [s]$'
set ylabel '$T [K]$'
set border lw 3
set xrange [0:0.03]
set yrange [1700:2800]

set multiplot

f1 = 'tvsD_0.1.txt'
f2 = 'tvsD_0.2.txt'
f3 = 'tvsD_0.3.txt'
f4 = 'tvsD_0.5.txt'
f5 = 'tvsD_0.7.txt'
f6 = 'sima.txt'
f7 = 'liu.txt'

set lmargin at screen 0.2
set rmargin at screen 0.9
set bmargin at screen 0.2
set tmargin at screen 0.6


set label '${T_g}_i=1320K$' at 115,46 
set label '$\epsilon=0.1$' at 128,32 
set label '$\epsilon=0.2$' at 128,29
set label '$\epsilon=0.3$' at 128,26 
set label '$\epsilon=0.5$' at 128,20 


set key at graph 0.45, graph 1
p f1 u 1:2 t 'current study' w lp ls 116\
 ,f2 u 1:2 ev :::0::0 notitle w lp ls 116\
 ,f3 u 1:2 ev :::0::0 notitle w lp ls 116\
 ,f4 u 1:2 ev :::0::0 notitle w lp ls 116\
 ,f6 u 1:2 ev :::0::0 t 'Farazi et al.' w lp ls 181 lw 4 dt '-.'\
 ,f7 u 1:2 ev :::0::0 t 'Liu et al.' w lp ls 183 lw 4 dt '-'\

unset key
unset multiplot
unset log

load 'def.gnu'
#-------------------------------------------------------------

