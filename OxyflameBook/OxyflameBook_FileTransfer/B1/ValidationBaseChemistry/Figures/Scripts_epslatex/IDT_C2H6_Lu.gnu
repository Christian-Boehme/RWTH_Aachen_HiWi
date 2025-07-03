#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#-------------------------------------------------------------

set term epslatex standalone color size fh,fw font "Times, 17"
set out '../figures_epslatex/IDT_C2H6_Lu.tex'

set encoding utf8
set termoption enhanced

#set xtics 0.0,0.05,2.0
#set ytics 0,0.003,3000
set mxtics 1
set mytics 5

#set title ''
set xlabel '$\mathrm{1000/T [K\textsuperscript{-1}]}$'
set ylabel '$\tau_\mathrm{ign}$ [ms]' offset 1.0,0.0
set border lw 2
set xrange [0.70:0.90]
#set yrange [0.001:1000000]

set multiplot
set logscale y

# Experiments
f1 = '../ExperimentalData/IDT_C2H6_Lu_LP.txt'
f2 = '../ExperimentalData/IDT_C2H6_Lu_HP.txt'
# FM simulations
f4 = ARG1
f5 = ARG2
f6 = ARG3
f7 = ARG4

set label '$\mathrm{\phi}$ = 0.5' at graph 0.03, graph 0.90

set key at graph 0.975, graph 0.25 spacing 1.1 samplen -1.5
p f1 u 1:($2*1E+00) t '0.8 atm' w p ps psize pt 7 lw plw lc rgb 'blue'\
 ,f2 u 1:($2*1E+00) t '2.0 atm' w p ps psize pt 9 lw plw lc rgb 'black'\
 ,f4 u ($2):3 notitle w l lt 1 lw lwref lc rgb 'blue' dashtype 6\
 ,f5 u ($2):3 notitle w l lt 1 lw lwref lc rgb 'black' dashtype 6\
 ,f6 u ($2):3 notitle w l lt 1 lw lwnew lc rgb 'blue'\
 ,f7 u ($2):3 notitle w l lt 1 lw lwnew lc rgb 'black'\

# ,f1 u 1:($2*1E+00) notitle w p ps psize pt 7 lw plw lc rgb 'blue'\
# ,f2 u 1:($2*1E+00) notitle w p ps psize pt 9 lw plw lc rgb 'black'\

unset key
unset multiplot

#-------------------------------------------------------------
