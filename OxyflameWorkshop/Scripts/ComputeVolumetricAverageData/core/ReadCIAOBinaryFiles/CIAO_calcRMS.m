function Output_rmsDataSet = CIAO_calcRMS(Input_rmsDataSet, avgDataSet);

    Output_rmsDataSet = sqrt( abs( Input_rmsDataSet - avgDataSet .* avgDataSet ) );