function [ x1,x2,cond_mean ] = ComputeConditionalMeanHistograms2D( ...
    quantity_interest,array_1,array_2,n_bins)

    %Prepare array
    [a,b,c] = size(array_1);
    nx=a*b*c;
    [a,b,c] = size(array_2);
    ny=a*b*c;
    
    
    if (nx~=ny)
        disp('!!!!!!!!!!!!!!!!!!!! Error !!!!!!!!!!!!!!!!!!!!') 
        disp('!!!!!!!!!!!!!!!!!!!! Error !!!!!!!!!!!!!!!!!!!!') 
        disp('!!!!! x- and y-array need to be same size !!!!!') 
        disp('!!!!!!!!!!!!!!!!!!!! Error !!!!!!!!!!!!!!!!!!!!') 
        disp('!!!!!!!!!!!!!!!!!!!! Error !!!!!!!!!!!!!!!!!!!!') 
    end
    n=nx;
    
    array1 = reshape(array_1,[n 1]);
    array2 = reshape(array_2,[n 1]);
    array_tmp = reshape(quantity_interest,[n 1]);
    
    
    [N,X1_edges,X2_edges,binX,binY] = histcounts2(array1,array2,n_bins);
    
    x1=(X1_edges(2:end)+X1_edges(1:end-1))/2;
    x2=(X2_edges(2:end)+X2_edges(1:end-1))/2;
    
    cond_mean = zeros(n_bins,n_bins);
    
    for i=1:n
        cond_mean(binY(i),binX(i)) = cond_mean(binY(i), ...
            binX(i)) + array_tmp(i)/N(binX(i),binY(i));
    end 
    
    cond_mean(N'==0)=NaN;

end