# How to create the respective input files

## Cantera:
~~~~~~~~~~{sh}
ck2yaml --input Base.chmech --thermo Base.chthermo --transport BaseChemkin.trans --output Base.yaml
~~~~~~~~~~

## FlameMaster:
~~~~~~~~~~{sh}
ScanMan -i Base.chmech -t Base.chthermo -m BaseChemkin.trans -f chemkin -w
~~~~~~~~~~
