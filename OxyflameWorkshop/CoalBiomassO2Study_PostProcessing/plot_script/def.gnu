#!/usr/bin/gnuplot -persist
#
unset key
#set border 3
set xtics nomirror
set ytics nomirror
set key spacing 1.25 font "Times,24" samplen 3 nobox
unset key

#set term post enh eps color dashed rounded dl 6 font "Times,24" size 5,4
set term epslatex dashed rounded dl 6 

load 'palette.gnu'


lm_def=0.15
rm_def=0.95
bm_def=0.15
tm_def=0.95

set lmargin at screen lm_def
set rmargin at screen rm_def
set bmargin at screen bm_def
set tmargin at screen tm_def

lm2_def=0.1
bm2_def=0.06

ly1 = 0.85
lx1 = 0.75

lx2 = 0.38
ly2 = 0.42

set xtics auto
set ytics auto

set xrange [*:*]
set yrange [*:*]
