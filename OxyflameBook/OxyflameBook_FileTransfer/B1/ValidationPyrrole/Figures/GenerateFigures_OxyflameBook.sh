#!usr/bin bash

# kinetic model
mech_dir_ref="ITV_Chen2023"
#mech_dir_full="ITV-Base-Chemistry_FullGlarborg_C4H5Nmodule"
mech_dir_full="ITV-Base-Chemistry_RedGlarborg_C4H5Nmodule"
#mech_dir="ITVCoalBiomass_FullGlarborg_C4H5Nmodule"
mech_dir="ITVCoalBiomass_RedGlarborg_C4H5Nmodule"


# create output directory
mkdir -p Figures_OxyflameBook

# change directory
cd Scripts_OxyflameBook

Reference="../../Simulations/"$mech_dir_ref"/Molefraction.txt"
Full="../../Simulations/"$mech_dir_full"/Molefraction.txt"
Skeletal="../../Simulations/"$mech_dir"/Molefraction.txt"

echo 'Generating plots'
gnuplot -c Chen_C4H5N.gnu $Reference $Full $Skeletal
gnuplot -c Chen_CO.gnu $Reference $Full $Skeletal
gnuplot -c Chen_CO2.gnu $Reference $Full $Skeletal
gnuplot -c Chen_H2.gnu $Reference $Full $Skeletal
gnuplot -c Chen_CH2O.gnu $Reference $Full $Skeletal
gnuplot -c Chen_CH2CO.gnu $Reference $Full $Skeletal
gnuplot -c Chen_CH4.gnu $Reference $Full $Skeletal
gnuplot -c Chen_C2H2.gnu $Reference $Full $Skeletal
gnuplot -c Chen_C2H4.gnu $Reference $Full $Skeletal
gnuplot -c Chen_HCN.gnu $Reference $Full $Skeletal
gnuplot -c Chen_C2H3CN.gnu $Reference $Full $Skeletal
gnuplot -c Chen_CH3CN.gnu $Reference $Full $Skeletal
gnuplot -c Chen_C2H5CN.gnu $Reference $Full $Skeletal
gnuplot -c Chen_NH3.gnu $Reference $Full $Skeletal
gnuplot -c Chen_NO.gnu $Reference $Full $Skeletal
gnuplot -c Chen_NO2.gnu $Reference $Full $Skeletal
gnuplot -c Chen_CH3N.gnu $Reference $Full $Skeletal
#gnuplot -c Chen_C2H5N.gnu $Reference $Full $Skeletal
echo 'Convert eps to pdf'
cd ../Figures_OxyflameBook
ps2pdf -dEPSCrop Chen_C4H5N.eps
ps2pdf -dEPSCrop Chen_CO.eps
ps2pdf -dEPSCrop Chen_CO2.eps
ps2pdf -dEPSCrop Chen_H2.eps
ps2pdf -dEPSCrop Chen_CH2O.eps
ps2pdf -dEPSCrop Chen_CH2CO.eps
ps2pdf -dEPSCrop Chen_CH4.eps
ps2pdf -dEPSCrop Chen_C2H2.eps
ps2pdf -dEPSCrop Chen_C2H4.eps
ps2pdf -dEPSCrop Chen_HCN.eps
ps2pdf -dEPSCrop Chen_C2H3CN.eps
ps2pdf -dEPSCrop Chen_CH3CN.eps
ps2pdf -dEPSCrop Chen_C2H5CN.eps
ps2pdf -dEPSCrop Chen_NH3.eps
ps2pdf -dEPSCrop Chen_NO.eps
ps2pdf -dEPSCrop Chen_NO2.eps
ps2pdf -dEPSCrop Chen_CH3N.eps
#ps2pdf -dEPSCrop Chen_C2H5N.eps
echo 'Done'


# post-process
cd ../Figures_OxyflameBook
rm Merged.pdf
pdfunite *.pdf Merged.pdf

