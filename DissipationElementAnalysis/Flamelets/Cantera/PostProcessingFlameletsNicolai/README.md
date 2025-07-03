# CreateFigures.py
python3 CreateFigures.py -h

## Calculate missing data based on flamelets from Nicolai
Missing variables: mixture fraction and dissipation rate ( +Wmix and D) (input file in core/ was generated form ITV-mechanisms)
-> details about the process can be found in MechanismDependentFunctionsForAppliedFlameletGasPhaseModel/
=> run: python3 CreateFigure.py -o <output_path> -i ../InputData/Flamelets_preheated/* -vy Z,chi,grad -vx x -save
=> all missing variables for each flamelet are post-processed and saved as csv files

## How to plot flamelets
python3 CreateFigure -i <input> -o <output_path> -vy <variable(s) on y-axis> -vx <variabel on x-axis>
-> muliple variabels on y-axis lead to multiple figures

# RelativeError.py
caluclates the relative error between two data files for one specific column and creates the respecitve figure
python3 RelativeError.py -i1 <filename> -i2 <filename> -o <output_path> -x <x_data_xcolumn> -y <column_header> -l1 <label1> -l2 <label2>

# GradientValidation.py
calculates the absolute difference or relative error (flag "-rel") from the gradient g (sqrt(chi/6/D) - 2D(dZ/dx)²)
python3 GradientValidation.py -i <filename> -o <output_path> -rel
