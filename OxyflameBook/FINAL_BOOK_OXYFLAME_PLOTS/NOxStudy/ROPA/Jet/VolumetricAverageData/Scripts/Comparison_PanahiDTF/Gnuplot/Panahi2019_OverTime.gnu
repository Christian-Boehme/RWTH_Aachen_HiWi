#!/usr/bin/gnuplot -persist

set term postscript eps color font "Times, 32"
set out 'figures/Panahi2019_OverTime.eps'

set termoption enhanced
set encoding utf8

set xtics 0,200,1000
#set ytics 0,1,1E+06
set mxtics 2
set mytics 1

set xlabel "time [ms]"
set ylabel "X_{NO_{x,exit}} [ppm]"
set border lw 2
set xrange [0:1000]
set yrange [0:*]

set multiplot

f1 = "~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/Validation_SINGLE/Panahi2019_DTF90_288_40_40_Tgas1300K/LastPlain_x288/VolumetricAverageMoleFractions.txt"
f2 = "~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/Validation_SINGLE/Panahi2019_DTF90_288_40_40_Tgas1400K/LastPlain_x288/VolumetricAverageMoleFractions.txt"
f3 = "~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/Validation_SINGLE/Panahi2019_DTF90_288_40_40_Tgas1500K/LastPlain_x288/VolumetricAverageMoleFractions.txt"
f4 = "~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/Validation_SINGLE/Panahi2019_DTF90_288_40_40_Tgas1300K_Pooria/LastPlain_x288/VolumetricAverageMoleFractions.txt"
f5 = "~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/Validation_SINGLE/Panahi2019_DTF90_288_40_40_Tgas1400K_Pooria/LastPlain_x288/VolumetricAverageMoleFractions.txt"
f6 = "~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/Validation_SINGLE/Panahi2019_DTF90_288_40_40_Tgas1500K_Pooria/LastPlain_x288/VolumetricAverageMoleFractions.txt"

factor = 1E+06
factorDprt = 1
factorScale = 1 #40.07

set key at graph 0.97, graph 0.97 samplen 2
p f1 u ($1*1000):((column("VolX_NO")+column("VolX_NO2"))*factor*factorDprt*factorScale) notitle w l lw 3 lc rgb "#e31a1c" dashtype 2\
 ,f2 u ($1*1000):((column("VolX_NO")+column("VolX_NO2"))*factor*factorDprt*factorScale) notitle w l lw 3 lc rgb "black" dashtype 2\
 ,f3 u ($1*1000):((column("VolX_NO")+column("VolX_NO2"))*factor*factorDprt*factorScale) notitle w l lw 3 lc rgb "#1f78b4" dashtype 2\
 ,f4 u ($1*1000):((column("VolX_NO")+column("VolX_NO2"))*factor*factorDprt*factorScale) title 'T=1300K' w l lw 3 lc rgb "#e31a1c"\
 ,f5 u ($1*1000):((column("VolX_NO")+column("VolX_NO2"))*factor*factorDprt*factorScale) title 'T=1400K' w l lw 3 lc rgb "black"\
 ,f6 u ($1*1000):((column("VolX_NO")+column("VolX_NO2"))*factor*factorDprt*factorScale) title 'T=1500K' w l lw 3 lc rgb "#1f78b4"\

#p f1 u ($1*1000):((column("VolX_NO")+column("VolX_NO2"))*factor*factorDprt) title 'T=1300K' w l lw 4 lc rgb "#e31a1c"\
# ,f2 u ($1):((column("X-NO")+column("X-NO2"))*factor*factorDprt) notitle w l lw 4 lc rgb "#e31a1c" dashtype 2\
# ,f3 u ($1*1000):((column("VolX_NO")+column("VolX_NO2"))*factor*factorDprt) title 'T=1400K' w l lw 4 lc rgb "black"\
# ,f4 u ($1):((column("X-NO")+column("X-NO2"))*factor*factorDprt) notitle w l lw 4 lc rgb "black" dashtype 2\
# ,f5 u ($1*1000):((column("VolX_NO")+column("VolX_NO2"))*factor*factorDprt) title 'T=1500K' w l lw 4 lc rgb "#1f78b4"\
# ,f6 u ($1):((column("X-NO")+column("X-NO2"))*factor*factorDprt) notitle w l lw 4 lc rgb "#1f78b4" dashtype 2\

unset key
unset multiplot

#-------------------------------------------------------------

