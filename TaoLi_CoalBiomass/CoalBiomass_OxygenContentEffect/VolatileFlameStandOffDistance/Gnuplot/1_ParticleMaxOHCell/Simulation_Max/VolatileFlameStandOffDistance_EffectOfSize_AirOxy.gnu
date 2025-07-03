#!/usr/bin/gnuplot -persist

set term postscript eps enhanced color font "Times, 32"
set out 'figures/VolatileFlameStandOffDistance_EffectOfSize_AirOxy.eps'

#set xtics 0,40,240
#set ytics 0,0.003,0.018
set mxtics 2
set mytics 2

set xtics mirror
set ytics mirror

set xlabel 'D_{par} [µm]'
set ylabel 'r_{f}/r_p [-]'
set border lw 2
set xrange [75:175]
set yrange [0:8]

set multiplot

# simulation data
f1 = '../../../Data/1_ParticleMaxOHCell/Sim_Coal_EffectOfSize_Air_sim_max.csv'
f2 = '../../../Data/1_ParticleMaxOHCell/Sim_Coal_EffectOfSize_Oxy_sim_max.csv'
f3 = '../../../Data/1_ParticleMaxOHCell/Sim_WS_EffectOfSize_Air_sim_max.csv'
f4 = '../../../Data/1_ParticleMaxOHCell/Sim_WS_EffectOfSize_Oxy_sim_max.csv'

set key at graph 0.97, graph 0.97 samplen 3
set key spacing 1.0
p f1 u ($1):($2) t 'Coal: Air' w lp pt 9 ps 3 lw 4 lc rgb '#1f78b4' dashtype 2\
 ,f2 u ($1):($2) t 'Coal: Oxy' w lp pt 9 ps 3 lw 4 lc rgb '#1f78b4'\
 ,f3 u ($1):($2) t 'WS: Air' w lp pt 9 ps 3 lw 4 lc rgb '#e31a1c' dashtype 2\
 ,f4 u ($1):($2) t 'WS: Oxy' w lp pt 9 ps 3 lw 4 lc rgb '#e31a1c'\

unset key
unset multiplot

#-------------------------------------------------------------

