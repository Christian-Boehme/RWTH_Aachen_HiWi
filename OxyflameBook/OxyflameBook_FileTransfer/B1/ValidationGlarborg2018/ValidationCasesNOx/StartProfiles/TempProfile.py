#!/usr/bin/env python3
import numpy as np  

A = 325.194
B = 1503.34
C = -0.0039 
D = 3.032 
E = -0.0809       
xs = np.linspace(0, 20, 20)  

def TempModel (x,A,B,C,D,E): 
    y = A +  B*(1-np.exp(C*(x**D))) + E*(x**2)  
    return y 
    
f = open("CH4Rich", "a")
for x in np.nditer(xs):
    y = TempModel(x,A,B,C,D,E)
    #convert to cm
    x_cm = x/10  
    fileLine = str(x_cm) + "\t" + str(y) + "\n"    
    f.write(fileLine) 

f.close()


