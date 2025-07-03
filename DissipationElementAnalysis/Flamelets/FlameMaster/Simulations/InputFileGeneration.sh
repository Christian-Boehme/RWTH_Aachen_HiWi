#!/usr/bin/bash

# This script creates all required FlameMaster.input files

echo 'Directory: '
read dir

# General data
mech="../KineticModel/Base.chmech.pre"
Pres=101325
Dist=0.15

# Unity lewis
# strain rate factor 1.25???
# No radiation
# more initial data (?)

# Fuel side
YFCO=0.057
YFCO2=0.072
YFCH4=0.087
YFH2O=0.268
YFC2H2=0.516

Tfuel=300
Fmdot=0.8


# Oxidizer side
YOH2O=0.0856
YOCO2=0.1042
YOO2=0.2242
YON2=0.586

Toxid=300
Omdot=0.8


# create sub-directory

# ...
StartProf=
FM="FlameMaster_yourInputFile.input"
StrainRate=
python3 ../Scripts/GenerateCounterFlowInputFiles.py -YFCO $YFCO -YFCO2 $YFCO2 -YFCH4 $YFCH4 -YFH2O $YFH2O -YFC2H2 $YFC2H2 -Tfuel $Tfuel -Fmdot -$Fmdot -YOH2O $YOH2O -YOCO2 $YOCO2 -YOO2 $YOO2 -YON2 $YON2 -Toxid $Toxid -Omdot $Omdot -mech $mech -Pres $Pres -Dist $Dist -StartProf $StartProf -o $FM -a $StrainRate

