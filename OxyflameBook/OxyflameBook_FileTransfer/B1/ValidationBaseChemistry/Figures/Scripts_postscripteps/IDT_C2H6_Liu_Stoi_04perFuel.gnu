#!/usr/bin/gnuplot -persist

#-------------------------------------------------------------
# Gloabal settings
#-------------------------------------------------------------
load 'Setup.gnu'
#------------------------------------------------------------

set term postscript size fw,fh eps font "Times, 36" color
set out '../figures_postscripteps/IDT_C2H6_Liu_Stoi_04perFuel.eps'

set encoding utf8
set termoption enhanced

#set xtics 0.0,0.05,2.0
#set ytics 0,0.003,3000
set mxtics 1
set mytics 5

set xlabel '1000/T [1/K]'
set ylabel '{/Symbol t}_{ign} [ms]' offset 0.25,0.0
set border lw 2
set xrange [0.65:0.95]
#set yrange [0.001:1000000]

set multiplot
set logscale y
set lmargin at screen 0.25
set rmargin at screen 0.95

# Experiments
f1 = '../ExperimentalData/IDT_C2H6_Liu_LP_Stoi_04perFuel.txt'
f2 = '../ExperimentalData/IDT_C2H6_Liu_HP_Stoi_04perFuel.txt'
# FM simulations
f4 = ARG1
f5 = ARG2
f6 = ARG3
f7 = ARG4

set label '{/Symbol f} = 1.0, X_{C_2H_6} = 0.04' at graph 0.03, graph 0.90

set key at graph 0.975, graph 0.25 spacing 1.1 samplen -1.5
p f1 u 1:($2*1E+00) t '0.8 atm' w p ps psize pt 7 lw plw lc rgb 'blue'\
 ,f2 u 1:($2*1E+00) t '2.0 atm' w p ps psize pt 9 lw plw lc rgb 'black'\
 ,f4 u ($2):3 notitle w l lt 1 lw lwref lc rgb 'blue' dashtype 2\
 ,f5 u ($2):3 notitle w l lt 1 lw lwref lc rgb 'black' dashtype 2\
 ,f6 u ($2):3 notitle w l lt 1 lw lwnew lc rgb 'blue'\
 ,f7 u ($2):3 notitle w l lt 1 lw lwnew lc rgb 'black'\

# ,f1 u 1:($2*1E+00) notitle w p ps psize pt 7 lw plw lc rgb 'blue'\
# ,f2 u 1:($2*1E+00) notitle w p ps psize pt 9 lw plw lc rgb 'black'\

unset key
unset multiplot

#-------------------------------------------------------------
