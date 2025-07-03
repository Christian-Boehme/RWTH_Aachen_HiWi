#!/usr/bin/env/ python3 

import re 
import os 
import numpy as np 
import pandas as pd
import glob  
import matplotlib.pyplot as plt 
from PIL import Image
import matplotlib.backends.backend_pdf 

# CHRISTIAN
import sys
Cdirectory = sys.argv[1]
if not Cdirectory.endswith('/'):
    Cdirectory += '/'
if not os.path.exists(Cdirectory):
    os.makedirs(Cdirectory)

class PlotGroup:  


     def __init__(self): 
         self.plotDic = {} 

     def returnPlot(self,plotName,key): 
         for plot in self.plotDic[key]: 
             if plot.id == plotName: 
                return plot

class Plot: 
     
      def __init__(self,name): 
          self.id = name 
          self.NameOfTheFolder = "" 
          self.Caption = "" 
          self.Flame = "" 
          self.PlotType = ""
          self.VOI = "" 
          self.SimulationsFile = [] 
          self.Legend = [] 
          self.Color = [] 
          self.ExperimentsFile = []
          self.Marker = [] 
          self.Ylabel = "" 
          self.Xlabel = "" 
          self.YUnit = "" 
          self.YConvFac = 1 
          self.XUnit = "" 
          self.XConvFac = 1 
          self.PlotWith = [] 
          self.IsPlotted = False
          self.fileToPlot = ""
          self.LineStyle = "-"  
          self.LogScale = 0 

      def AddPlotInfo(self, name, NameOfTheFolder,  Caption, Flame, PlotType, VOI, SimulationsFile, Legend, Color, ExperimentsFile, Ylabel, Xlabel, YUnit, YConvFac, XUnit, XConvFac, PlotWith, LineStyle, Marker, LogScale): 
          self.NameOfTheFolder = NameOfTheFolder 
          self.Caption = Caption 
          self.Flame = Flame 
          self.PlotType = PlotType 
          self.VOI = VOI.split(" ") 
          self.SimulationsFile = SimulationsFile.split(" ")
          self.Legend = Legend.split(" ") 
          self.Color = Color.split(" ") 
          self.ExperimentsFile = ExperimentsFile.split(" ") 
          self.Marker = Marker.split(" ") 
          self.Ylabel = Ylabel 
          self.Xlabel = Xlabel 
          self.YUnit = YUnit
          self.XUnit = XUnit
          self.LogScale = int(LogScale)  
          if LineStyle != "": 
             self.LineStyle = LineStyle  
          if YConvFac:  
             self.YConvFac = YConvFac 
          if XConvFac: 
             self.XConvFac = XConvFac 
          if PlotWith: 
             self.PlotWith = PlotWith.split(" ") 

      def WriteSimulationsFile(self): 
          working_dir = os.getcwd() 
          path = os.path.join(working_dir,"Simulations") 
          path = os.path.join(path,self.NameOfTheFolder) 
          path_file = os.path.join(path,self.id) 
          
          self.fileToPlot = path_file 
           
          df1 = pd.DataFrame() 
          join = "" 
          
          #Extract species info from Simulations File 
          if re.findall(r"MoleFraction|MassFraction|Concentration|Temperature",self.PlotType,re.I) and re.findall(r"PostFlame|ST|McKenna|FreelyProp|JSR|FR",self.Flame,re.I): 
             i = 0
             k = 0 
             for sim_file in self.SimulationsFile: 
                 current_path = os.path.join(working_dir,sim_file) 
                 if re.findall(r"McKenna|FreelyProp|PostFlame",self.Flame,re.I): 
                    file_path = os.path.join(current_path,"*.kg")
                    if re.findall(r"MassFraction",self.PlotType,re.I):
                       if re.findall(r"PostFlame",self.Flame,re.I): 
                          join = "Y-" 
                       else:                                         
                          join = "massfraction-" 
                    if re.findall(r"MoleFraction",self.PlotType,re.I) :
                       if re.findall(r"PostFlame",self.Flame,re.I): 
                          join = "X-" 
                       else:                                         
                          join = "X-"#"molefraction-" # CHRISTIAN # different FM version??
                    if re.findall(r"Temperature",self.PlotType,re.I):
                       join = " [K]" 

                 elif re.findall(r"ST|FR",self.Flame,re.I): 
                    if self.PlotType == "MassFraction":                                         
                       file_path = os.path.join(current_path,"Y1*")
                       join = "Y-" 
                    if self.PlotType == "MoleFraction":
                       file_path = os.path.join(current_path,"X1*")
                       join = "X-"
                    if self.PlotType == "Concentration":
                       file_path = os.path.join(current_path,"C1*")
                       join = "C-" 
                 elif re.findall(r"JSR",self.Flame,re.I): 
                    if self.PlotType == "MassFraction":                                         
                       file_path = os.path.join(current_path,"PSR_Y*")
                       join = "Y-" 
                    if self.PlotType == "MoleFraction":
                       file_path = os.path.join(current_path,"PSR_X*")
                       join = "X-"
                    if self.PlotType == "Concentration":
                       file_path = os.path.join(current_path,"PSR_C*")
                       join = "C-" 
 

                 listsofFile = glob.glob(file_path)
                 if len(listsofFile) > 1 and re.findall(r"(PostFlame|ST|McKenna|FreelyProp)",self.Flame,re.I): 
                    exit("Found more than 1 MoleFraction|MassFraction file in " + self.NameOfTheFolder)
                 if not listsofFile: 
                    exit("Cannot find simulations file in dir " + current_path) 
                 
                 if len(listsofFile) > 1 and re.findall(r"JSR|FR",self.Flame,re.I):
                    df = pd.DataFrame()
                    x_list = []
                    y_list = {}  
                    j = 0 
                    listsofFile.sort() 
                    for elem in listsofFile:
                        print(elem)
                        temp = pd.read_csv(elem,sep =r"\s+", skiprows=1) # "\t",skiprows=1 )
                        print(temp.columns)
                        for column in temp.columns.tolist(): 
                            temp.rename(columns = {column:column.strip()}, inplace = True) 

                        if re.findall(r"Temp", self.Xlabel): 
                           column_y = "T[K]"
                           if re.findall(r"FR",self.Flame,re.I):  
                              x_list.append(temp.iloc[-1,1]) 
                           else: 
                              x_list.append(temp.iloc[-1,0])
 
                           for elem in self.VOI:                               
                               name = join + elem.strip()
                               if name in y_list.keys(): 
                                  y_list[name].append(temp.iloc[-1,temp.columns.get_loc(name)]) 
                               else: 
                                  y_list[name] = [temp.iloc[-1,temp.columns.get_loc(name)]] 
                               

                        elif re.findall(r"time", self.Xlabel): 
                           column_y = "t[s]"
                           x_list.append = temp.iloc[-1,0]
                           for elem in self.VOI: 
                               name = join + elem.strip()
                               if name in y_list.keys(): 
                                  y_list[name].append(temp.iloc[-1,temp.columns.get_loc(name)]) 
                               else: 
                                  y_list[name] = [temp.iloc[-1,temp.columns.get_loc(name)]] 
                    
                    df[column_y] = x_list 
                    for key in y_list.keys(): 
                        df[key] = y_list[key] 

  
                 elif len(listsofFile) == 1 and re.findall(r"JSR|FR",self.Flame):
                      df = pd.DataFrame()
                      temp = pd.read_csv(elem,sep = "\t",skiprows=1 )
                      #if re.findall(r"Temp", self.Xlabel): 
                      #     column_y = "T[K]"
                      #elif re.findall(r"time", self.Xlabel): 
                      #     column_y = "t[s]"
                        
                      #df.iloc[0,0] = temp.iloc[-1,temp.columns.get_loc(column_y)]
                      df.iloc[0,0] = temp.iloc[-1,0]
                      k = 1 
                      for elem in self.VOI: 
                          name = join + elem.strip()  
                          df.iloc[j,k] = temp.iloc[-1,temp.columns.get_loc(name)]
                          k += 1    
                 else:
                   df = pd.read_csv(listsofFile[0],sep = "\t",skiprows=1 )
         
                 for column in df.columns.tolist(): 
                     df.rename(columns = {column:column.strip()}, inplace = True)  

                 if self.XConvFac !=  1.0:
                    df.iloc[:,0] = df.iloc[:,0].multiply(self.XConvFac)

                 column_y = self.XUnit + "_" + str(k)
                 k+=1 
                 if  re.findall(r"PostFlame",self.Flame,re.I):  
                     df1[column_y] = df.iloc[:,2] 
                 else: 
                     df1[column_y] = df.iloc[:,0]

                 for elem in self.VOI: 
                     if re.findall(r"Temp",elem,re.I): 
                        name = elem.strip() + join 
                     else: 
                        name = join + elem.strip()

                     name2 = name + "_" + str(i)
                     x_axis = column_y+ "_" + str(i)
                     if self.YConvFac != 1.0:   
                        df.loc[:,name.strip()] = df.loc[:,name.strip()].multiply(self.YConvFac)

                     if re.findall("JSR|FR",self.Flame,re.I):                         
                        df1[name2] = df[name]
                     elif re.findall(r"Temperature",self.PlotType,re.I) and re.findall(r"McKenna",self.Flame,re.I) :
                        df1[name2] = df["temperature [K]"]
                     else:         
                        df1[name2] = df.loc[:,name]
                 i+=1 
                                  
          #Extract IDT info from Simulations file 
          elif re.findall(r"IDT",self.PlotType) and re.findall(r"ST",self.Flame):
               i = 0 
               for sim_file in self.SimulationsFile: 
                   current_path = os.path.join(working_dir,sim_file)
                   file_path = os.path.join(current_path,"*_IgniDelTimes.dout")  
                   listsofFile = glob.glob(file_path)
                   if len(listsofFile) > 1: 
                      exit("Found more than 1 IDT file in " + self.NameOfTheFolder)
                   if not listsofFile: 
                      exit("Cannot find simulations file in dir " + current_path) 
                     
                   df = pd.read_csv(listsofFile[0],sep = "\t",skiprows=1 )
                   column_y = self.XUnit
                   df1[column_y] = df.iloc[:,0]
                   for elem in self.VOI: 
                     name2 = "IDT_" + str(i)
 
                     if self.YConvFac != 1.0:              
                        df.iloc[:,1] = df.iloc[:,1].multiply(self.YConvFac)
                             
                     df1[name2] = df.iloc[:,1]
                   i+=1

          #Extract LBV info from Simulations File 
          elif re.findall(r"LBV",self.PlotType,re.I) and re.findall(r"FreelyProp",self.Flame,re.I):
               i = 0 
               for sim_file in self.SimulationsFile: 
                   current_path = os.path.join(working_dir,sim_file)
                   file_path = os.path.join(current_path,"syms.out")  
                   listsofFile = glob.glob(file_path)
                   if len(listsofFile) > 1: 
                      exit("Found more than 1 LBV file in " + self.NameOfTheFolder)
                   if not listsofFile: 
                      exit("Cannot find simulations file " + file_path + ". Maybe you forgot to generate it with ListTool") 
                     
                   df = pd.read_csv(listsofFile[0],sep = "\t",skiprows=1 )
                   column_y = self.XLabel 
                   if re.findall("pressure",self.XLabel,re.I): 
                      if self.XConvFac !=  1.0: 
                         df.iloc[:,0] = df.iloc[:,0].multiply(self.XConvFac)
                      df1[column_y] = df.iloc[:,0]
                   elif re.findall("phi",self.XLabel,re.I):
                        if self.XConvFac !=  1.0: 
                           df.iloc[:,1] = df.iloc[:,1].multiply(self.XConvFac)
                        df1[column_y] = df.iloc[:,1]
                                           
                   for elem in self.VOI: 
                     name2 = "LBV_" + str(i)
 
                     if self.YConvFac != 1.0:              
                        df.iloc[:,2] = df.iloc[:,2].multiply(self.YConvFac)
                             
                     df1[name2] = df.iloc[:,2]
                   i+=1 
 
    
          df1.to_csv(path_file, sep = "\t",index = False)
 
      def CreatePlotFigure(self,all_plots,folder,num_fig): 

          lineStyle = []  
          self.IsPlotted = True
          Plots = []
          working_dir = os.getcwd() 
          current_path = os.path.join(working_dir,"Simulations")
          current_path = os.path.join(current_path,folder)
           
          plt.figure(num_fig) 
          Plots.append(self) 
          if self.PlotWith: 
             for elem in self.PlotWith:
                 side_plot = all_plots.returnPlot(elem,folder) 
                 name_fig = side_plot.id + ".png" 
                 if os.path.isfile(os.path.join(current_path,name_fig)): 
                    os.remove(os.path.join(current_path,name_fig))
                 side_plot.IsPlotted = True 
                 Plots.append(side_plot)
          

          x_lim_r = 0 
          x_lim_l = 10000000 
          y_lim_r = 0 
          y_lim_l = 10000000000 
          
          for plot in Plots: 
              if not re.findall(r"FR|ST",plot.Flame,re.I):  
                 Sim = pd.read_csv(plot.fileToPlot, sep = "\t", skiprows = 1,header=None)
                 Sim.to_csv(Cdirectory + plot.fileToPlot.split('/')[-1], sep='\t', float_format='%.6E', index=False) # Christian
                 i = 0
                 j = 0
                 while i< (len(Sim.columns.tolist())-1): 
                      plt.plot(Sim.iloc[:,i],Sim.iloc[:,i+1],color = plot.Color[j], linestyle=plot.LineStyle)
                      j+=1    
                      i+=2
              else: 
                 if re.findall(r"ST",plot.Flame,re.I) and len(plot.SimulationsFile) !=1: 
                    Sim = pd.read_csv(plot.fileToPlot, sep = "\t", skiprows = 1,header=None)
                    Sim.to_csv(Cdirectory + plot.fileToPlot.split('/')[-1], sep='\t', float_format='%.6E', index=False) # Christian
                    i = 0
                    j = 0
                    while i< (len(Sim.columns.tolist())-1): 
                       plt.plot(Sim.iloc[:,i],Sim.iloc[:,i+1],color = plot.Color[j], linestyle=plot.LineStyle)
                       j+=1    
                       i+=2
 
                 else:  
                    Sim = pd.read_csv(plot.fileToPlot, sep = "\t")
                    j = 0  
                    for elem in Sim.columns.tolist():
                        if not elem == Sim.columns.tolist()[0]:  
                           Sim.to_csv(Cdirectory + plot.fileToPlot.split('/')[-1], sep='\t', float_format='%.6E', index=False) # Christian
                           plt.plot(Sim.iloc[:,0],Sim[elem],color = plot.Color[j], linestyle=plot.LineStyle)
                           j +=1 
         
              for exp in plot.ExperimentsFile:
                  Exp = pd.read_csv(exp, sep = ";")
                  if x_lim_r < Exp.iloc[:,0].max(): 
                     x_lim_r =  Exp.iloc[:,0].max()
                  if x_lim_l > Exp.iloc[:,0].min(): 
                     x_lim_l =  Exp.iloc[:,0].min()
                  if y_lim_r < Exp.iloc[:,1].max():  
                     y_lim_r =  Exp.iloc[:,1].max()
                  if y_lim_l > Exp.iloc[:,1].min(): 
                     y_lim_l =  Exp.iloc[:,1].min()

              
          y_lim_r = y_lim_r + (0.50*y_lim_r)  
          y_lim_l = y_lim_l - (0.50*y_lim_l) 
          x_lim_l = x_lim_l - (0.05*x_lim_l)
          x_lim_r = x_lim_r + (0.05*x_lim_r)
          for plot in Plots: 
              j = 0
              for exp in plot.ExperimentsFile:
                  Exp = pd.read_csv(exp, sep = ";",header=None)
                  for (index, colname) in enumerate(Exp):
                      if index != 0:
                         plt.plot(Exp.iloc[:,0],Exp.iloc[:,index],plot.Marker[j] ,color = plot.Color[j],label = plot.Legend[j])   
                         j+=1 
   
          Xlabel = self.Xlabel + self.XUnit 
          Ylabel = self.Ylabel + self.YUnit 

          if self.LogScale == 1: 
             plt.yscale("log") 

          plt.legend()
          plt.xlim(x_lim_l,x_lim_r) 
          plt.ylim(y_lim_l,y_lim_r)   
          plt.xlabel(Xlabel) 
          plt.ylabel(Ylabel) 
          plt.title(self.Caption, loc='left')
          fig_name = self.id + ".png" 
          os.chdir(current_path) 
          plt.savefig(fig_name, bbox_inches='tight')
          os.chdir(working_dir) 


      

def ReadInfoPlot(filename,NameOfTheFolder): 
     
    listOfPlot = [] 
    
    try: 
     f = open(filename, 'r')
    except IOEriror:
     print("Couldn't open InfoPlot file ") 
   
    info = f.readlines()
    f.close() 
    
    name = ""; Caption = ""; Flame = ""; PlotType = ""; VOI = ""; SimulationsFile = ""; Legend = ""; Color = ""; ExperimentsFile = ""; 
    Ylabel = ""; Xlabel = ""; YUnit = ""; XUnit = ""; YConvFac = 1; XConvFac = 1; PlotWith = ""; LineStyle = ""; Marker = ""  
    LogScale = 0;  
    i = 0  
    while i < (len(info)-1): 
    
     if re.findall(r"#",info[i]): 
        i+=1  
     if re.findall(r"Plot{",info[i]): 
        i+=2 
        if re.findall(r"Name:",info[i]): 
           line=info[i].split(":") 
           name = line[1].strip() 
           plot = Plot(line[1].strip()) 
           i+=1
        if re.findall(r"Caption:",info[i]): 
         line=info[i].split(":") 
         Caption = line[1].strip()
         i+=1 
        if re.findall(r"Flame:",info[i]): 
         line=info[i].split(":") 
         Flame = line[1].strip()
         if not re.findall(r"(PostFlame|McKenna|JSR|FR|ST|FreelyProp)",Flame,re.I): 
            exit("Flame Option are: PostFlame,McKenna,FR,ST,JSR,FreelyProp") 
         i+=1
        if re.findall(r"PlotType:",info[i]): 
         line=info[i].split(":") 
         PlotType = line[1].strip()
         if not re.findall(r"temperature|IDT|LBV|MassFraction|MoleFraction|Concentration",PlotType,re.I): 
            exit("PlotType options are: temperature, IDT, LBV, MassFraction, MoleFraction, Concentration")
         i+=1
        if re.findall(r"VOI:",info[i]): 
         line=info[i].split(":") 
         VOI = line[1].strip() 
         i+=1
        if re.findall(r"SimulationsFile:",info[i]): 
         line=info[i].split(":") 
         SimulationsFile = line[1].strip()
         i+=1
        if re.findall(r"Legend:",info[i]): 
         line=info[i].split(":") 
         Legend = line[1].strip() 
         i+=1
        if re.findall(r"Color:",info[i]): 
         line=info[i].split(":") 
         Color = line[1].strip() 
         i+=1
        if re.findall(r"ExperimentsFile:",info[i]): 
         line=info[i].split(":") 
         ExperimentsFile = line[1].strip() 
         i+=1
        if re.findall(r"Marker:",info[i]): 
         line=info[i].split(":") 
         Marker = line[1].strip() 
         i+=1
        if re.findall(r"Ylabel:",info[i]): 
         line=info[i].split(":") 
         Ylabel = line[1].strip() 
         i+=1
        if re.findall(r"Xlabel:",info[i]): 
         line=info[i].split(":") 
         Xlabel = line[1].strip() 
         i+=1
        if re.findall(r"YUnit:",info[i]): 
         line=info[i].split(":") 
         YUnit = line[1].strip() 
         i+=1
        if re.findall(r"YConvFac:",info[i]): 
         line=info[i].split(":")
         if line[1]:  
            YConvFac = float(line[1].strip()) 
         i+=1
        if re.findall(r"XUnit:",info[i]): 
         line=info[i].split(":") 
         XUnit = line[1].strip()
         i+=1
        if re.findall(r"XConvFac:",info[i]): 
         line=info[i].split(":") 
         if line[1]: 
            XConvFac = float(line[1].strip()) 
         i+=1
        if re.findall(r"SetLogScaleY:",info[i]):
         line=info[i].split(":") 
         LogScale = line[1].strip() 
         i+=1
        if re.findall(r"PlotWith:",info[i]): 
         line=info[i].split(":") 
         PlotWith = line[1].strip() 
         i+=1
        if re.findall(r"LineStyle:",info[i]): 
         line=info[i].split(":") 
         LineStyle = line[1].strip() 
         i+=1
     
        else: 
   
           i+=1 

        plot.AddPlotInfo(name, NameOfTheFolder,  Caption, Flame, PlotType, VOI, SimulationsFile, Legend, Color, ExperimentsFile, Ylabel, Xlabel, YUnit, YConvFac, XUnit, XConvFac, PlotWith, LineStyle, Marker, LogScale) 
        listOfPlot.append(plot) 
    
     
     else: 
        i+=1   
  
    return listOfPlot  

     
# Added for compatibility with new Python environment with Rocky OS
matplotlib.use('Agg')
############
working_dir = os.getcwd()
working_dir = os.path.join(working_dir,"Simulations") 
plotsGlobal = PlotGroup() 

for files in os.listdir(working_dir):
    current_path = os.path.join(working_dir,files) 
    if os.path.isdir(current_path): 
       fileName = "InfoPlot" 
       if os.path.isfile(os.path.join(current_path,fileName)):
          if os.path.isfile(os.path.join(current_path,"Plot*")): 
             os.remove(os.path.join(current_path,"Plot*"))
          file_path = os.path.join(current_path,"*png") 
          listsofFile = glob.glob(file_path) 
          if listsofFile: 
             for im in listsofFile: 
                 os.remove(im) 
          print("Reading simulations file for: " + files) 
          listOfPlot = ReadInfoPlot(os.path.join(current_path,fileName), files) 
          if listOfPlot: 
             plotsGlobal.plotDic[files] = listOfPlot
          else: 
             print("#####WARNING: Wrong InfoPlot file in folder: "  +  files) 
    
for keys in plotsGlobal.plotDic.keys(): 
    plots = plotsGlobal.plotDic[keys]
    print("Generating simulations file for: " + keys) 
    for plot in plots: 
        plot.WriteSimulationsFile()
num_fig = 0 
for keys in plotsGlobal.plotDic.keys(): 
    plots = plotsGlobal.plotDic[keys]
    print("Generating figures for: " + keys) 
    for plot in plots: 
        if not plot.IsPlotted: 
           plot.CreatePlotFigure(plotsGlobal,keys,num_fig)  
           plot.IsPlotted = True 
           num_fig += 1 

print("Generating DataBase") 
listofImages = [] 
Fig_names = [] 
for keys in plotsGlobal.plotDic.keys(): 
    h = 0 
    w = 0
    current_path = os.path.join(working_dir,keys) 
    file_path = os.path.join(current_path,"*.png")
    listofFigures = glob.glob(file_path)
    for figure in listofFigures:
        img = Image.open(figure)
        w_img, h_img = img.size
        if max(w_img,w) > w: 
           w = max(w_img,w) 
        if max(h_img,h) > h: 
           h = max(h_img,h)
    print(keys)
    h_inc =int(len(listofFigures)/2) + (len(listofFigures) % 2 > 0) 
    if len(listofFigures) == 1: 
       new_image = Image.new('RGB', (w, h))
    else: 
       new_image = Image.new('RGB', (w*2, h*h_inc))

    h_pos = 0 
    w_pos = 0 
    fig_counter = 0
    img_w, img_h = new_image.size
    for figure in listofFigures:
        img = Image.open(figure)
        w_prev, h_prev = img.size
        new_image.paste(img,( w_pos, h_pos))
        w_pos = w_pos + (w + (w % 2 > 0))  
        fig_counter +=1
        if fig_counter == 2: 
           fig_counter = 0 
           w_pos = 0 
           h_pos = h_pos + round(img_h/h_inc) 
 
    Fig = keys + ".png"
    Fig_names.append(Fig)  
    new_image.save(Fig)
    listofImages.append(new_image) 

im1 = listofImages.pop(-1)  
im1.save("DataBase.pdf", save_all=True, append_images=listofImages) 
for fi in Fig_names: 
    os.remove(fi)  
          

 

