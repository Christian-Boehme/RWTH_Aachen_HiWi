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
set out 'plot.tex'

##### grid #####
set style line 102 lc rgb '#808080' lt 0 lw 1

zero(x)=0.0

####### FIRST ROW OF FIGURES ########
##### T over r #####
#set style rectangle fillstyle noborder
#set obj rect from graph 0.68, graph 0.85 to graph 0.92, graph 0.95 back

set title "A(1-7) with different {/Symbol e}" #offset 5.5,-3
#set label "Temperature" at graph 0.5,1
set border lw 2
set xlabel 'Particle Diameter [{/Symbol m}m]'
set  xrange [50:130]
set xtics 50,20,130
set mxtics 4
set grid xtics ytics back ls 102

#set lmargin at screen 0.1
#set rmargin at screen 0.8
#set bmargin at screen 0.2
#set tmargin at screen 0.8

set ylabel '{/Symbol t}_{igni}[ms]' offset 1.8
set yrange [0:50]
set ytics 10
set mytics 2
#set key at screen 0.5,0.99 spacing 1.4 samplen 4 width 1.5 vertical  maxrows 3
#set key Left reverse

plot 'tvsD_0.1.txt' u 1:2  ls 171 w lp t "FlameMaster({/Symbol e}=0.1)" , \
     'tvsD_0.2.txt' u 1:2  ls 171 w lp t "FlameMaster({/Symbol e}=0.2)" , \
     'tvsD_0.3.txt' u 1:2  ls 171 w lp t "FlameMaster({/Symbol e}=0.3)" , \
     'tvsD_0.5.txt' u 1:2  ls 171 w lp t "FlameMaster({/Symbol e}=0.5)" , \
     'sima.txt' u 1:2  ls 181 dt '.' w lp t "Farazi et al" , \
     'liu.txt' u 1:2  ls 182 dt '.' w lp t "exp by liu et al" , \
     zero(x) w l ls -1 notitle
#set mytics 
#unset key



unset label
































