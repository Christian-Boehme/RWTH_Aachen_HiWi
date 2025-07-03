#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Global settings
#-------------------------------------------------------------
load 'def.gnu'
load 'palette.gnu'
load 'const.gnu'
#-------------------------------------------------------------


#-------------------------------------------------------------
set term epslatex standalone color size 5,5
set out 'diss.tex'

set title "A(1-7) with different {/Symbol e}"
set xlabel  'Particle Diameter [{/Symbol m}m]'
set ylabel '{/Symbol t}_{igni}[ms]' 

set xrange [50:130]
set yrange [0:50]

set multiplot

set xtics 50,20,130
set mxtics 4

set ytics 10
set mytics 2


f1 = 'tvsD_0.1.txt'
f2 = 'tvsD_0.2.txt'
f3 = 'tvsD_0.3.txt'
f4 = 'tvsD_0.5.txt'
f5 = 'sima.txt'
f6 = 'liu.txt'



set lmargin at screen 0.2
set rmargin at screen 0.9
set bmargin at screen 0.2
set tmargin at screen 0.9

set key at graph 0.9, graph 0.9
p f1 u 1:2 t 'FlameMaster({/Symbol e}=0.1)' w lp ls 186\
 ,f2 u 1:2 t 'FlameMaster({/Symbol e}=0.2)' w lp ls 186\
 ,f3 u 1:2 t 'FlameMaster({/Symbol e}=0.3)' w lp ls 186\
 ,f4 u 1:2 t 'FlameMaster({/Symbol e}=0.5)' w lp ls 186\
 ,f5 u 1:2 t 'Farazi et al' w lp ls 186\
 ,f6 u 1:2 t 'Liu et al(experiment)' w lp ls 186\




unset key
unset multiplot
unset log
#set xtics auto
#set ytics auto

load 'def.gnu'
#-------------------------------------------------------------

