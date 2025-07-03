#!/usr/bin/gnuplot

# File return ymax and ntics for the yaxis

ini = int(ARG1)

ntics = 3
y_max = 3

round(x) = x - floor(x) < 0.5 ? floor(x) : ceil(x)

if (ini > 200) {
  ntics = 3
  y_max_data = ini
  #print '2->y_max = ', y_max_data
  y_max = round(y_max_data * 1.1)
  #print 'y_max = ', y_max
  do for [i=-10:100] {
    y_max_ = y_max + i
    if (int(4*round(y_max_/4)) % 4 == 0) {
      if (int(4*round(y_max_/4)) % 100 == 0) {
        y_max = int(4*round(y_max_/4))
        ntics = 4
        break
      }
      if (int(4*round(y_max_/4)) % 50 == 0) {
        y_max = int(4*round(y_max_/4))
        ntics = 4
        break
      }
    }
    if (int(3*round(y_max_/3)) % 3 == 0) {
      if (int(3*round(y_max_/3)) % 100 == 0) {
        y_max = int(3*round(y_max_/3))
        break
      }
      if (int(3*round(y_max_/3)) % 50 == 0) {
        y_max = int(3*round(y_max_/3))
        break
      }
    }
  }
  if (y_max_data > y_max) {
    print 'FAILED'
  }
  #print 'y_max = ', y_max
  #print 'ntics = ', ntics
}

if (ini > 105 && ini <=200 ) {
  ntics = 3
  y_max_data = ini
  #print '2->y_max = ', y_max_data
  y_max = round(y_max_data * 1.1)
  #print 'y_max = ', y_max
  do for [i=-10:25] {
    y_max_ = y_max + i
    if (int(4*round(y_max_/4)) % 4 == 0) {
      if (int(4*round(y_max_/4)) % 10 == 0) {
        y_max = int(4*round(y_max_/4))
        ntics = 4
        break
      }
    }
    if (int(3*round(y_max_/3)) % 3 == 0) {
      if (int(3*round(y_max_/3)) % 10 == 0) {
        y_max = int(3*round(y_max_/3))
        break
      }
    }
  }
  if (y_max_data > y_max) {
    print 'FAILED'
  }
  #print 'y_max = ', y_max
  #print 'ntics = ', ntics
}

if (ini > 30 && ini <= 105) {
  ntics = 3
  y_max_data = ini
  #print '1: y_max = ', y_max_data
  y_max = round(y_max_data * 1.1)
  #print 'y_max = ', y_max
  do for [i=-3:20] {
    y_max_ = y_max + i
    if (int(4*round(y_max_/4)) % 4 == 0) {
      if (int(4*round(y_max_/4)) % 10 == 0) { 
        if (y_max < int(4*round(y_max_/4))) {
          y_max = int(4*round(y_max_/4))
          ntics = 4
          break
        }
      }
      if (int(4*round(y_max_/4)) % 5 == 0) {
        if (y_max < int(4*round(y_max_/4))) {
         y_max = int(4*round(y_max_/4))
         ntics = 4
         break
        }
      }
    }
    if (int(3*round(y_max_/3)) % 3 == 0) {
      if (int(3*round(y_max_/3)) % 10 == 0) {
        if (y_max < int(3*round(y_max_/3))) {
          y_max = y_max_
          break
        }
      }
      if (int(3*round(y_max_/3)) % 5 == 0) {
        if (y_max < int(3*round(y_max_/3))) {
          y_max = int(3*round(y_max_/3))
          break
        }
      }
    }
  }
  if (y_max_data > y_max) {
    print 'FAILED'
  }
  #print 'y_max = ', y_max
  #print 'ntics = ', ntics
} 

if (ini > 1 && ini <= 30) {
  flag = 0
  ntics = 3
  y_max_data = ini
  #print '0->y_max = ', y_max_data
  y_max = round(y_max_data * 1.1)
  #print 'y_max = ', y_max
  do for [i=-3:20] {
    y_max_ = y_max + i
    do for [j=1:10] {
      if (int(4*round(y_max_/4)) % 4 == 0) {
        if (int(4*round(y_max_/4)) % j == 0) { 
          if (y_max < int(4*round(y_max_/4))) {
            y_max = int(4*round(y_max_/4))
            ntics = 4
            flag = 1
            break
          }
        }
      }
      if (int(3*round(y_max_/3)) % 3 == 0) {
        if (int(3*round(y_max_/3)) % j == 0) {
          if (y_max < int(3*round(y_max_/3))) {
            y_max = y_max_
            flag = 1
            break
          }
        }
      }
    }
    if (flag == 1) {break}
  }
  if (y_max_data > y_max) {
    print 'FAILED'
  }
  #print 'y_max = ', y_max
  #print 'ntics = ', ntics
}

