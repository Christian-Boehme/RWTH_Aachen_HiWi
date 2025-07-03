#!/usr/bin bash

gnuplot IDT_AIR20.gnu
gnuplot IDT_Dp125.gnu
cd figures
ps2pdf -dEPSCrop IgnitionDelayTime_WS_AIR20.eps
ps2pdf -dEPSCrop IgnitionDelayTime_WS_Dp125.eps
