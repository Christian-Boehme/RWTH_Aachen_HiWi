#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Global settings
#-------------------------------------------------------------
load 'def.gnu'
load 'palette.gnu'
load 'const.gnu'
#-------------------------------------------------------------


#-------------------------------------------------------------
set term epslatex standalone color size 5,4 dashlength 0.5 font ",20"
set out 'Moisture.tex'

set xtics 0,5,15
set ytics 0,2,10
set mxtics 2
set mytics 1

set xtics mirror
set ytics mirror
set xlabel '$t$ [ms]'
set ylabel 'Moisture [\%]'
set border lw 2
set xrange [0:15]
set yrange [0:10]

set multiplot

# simulation data
f1 = '~/NHR/Pooria/SINGLES/COL/AIR20-DP125/monitor_TaoLi/coal'
f2 = '~/NHR/Pooria/SINGLES/WS/AIR20-DP125/monitor_TaoLi/coal'

# ignition delay times
tign_coal = 8.30
tign_ws   = 7.40
set arrow from tign_coal, graph 0 to tign_coal, graph 1 nohead lw 2 lc rgb "#1f78b4"
set arrow from tign_ws, graph 0 to tign_ws, graph 1 nohead lw 2 lc rgb "#e31a1c" 

set key at graph 0.95, graph 0.97 samplen 2
set key spacing 2.0
p f1 u ($2*1000):(($67)*1E+02) t 'Coal' w l lw 4 lc rgb '#1f78b4'\
 ,f2 u ($2*1000):(($77)*1E+02)  t 'WS' w l lw 4 lc rgb '#e31a1c'

unset key
unset multiplot
unset log

load 'def.gnu'
#-------------------------------------------------------------

