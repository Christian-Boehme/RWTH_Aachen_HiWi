function [PDF_x1, PDF_x2, PDF_y] = Compute_PDF_histograms_2D(array_1, ...
    array_2, n_bins)

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
    
    [N,X1_edges,X2_edges] = histcounts2(array1,array2,n_bins);
    
    N_sum = sum(sum(N));
    
    dx=X1_edges(2)-X1_edges(1);
    dy=X2_edges(2)-X2_edges(1);
    
    PDF_y = N'./N_sum/dx/dy;
    
    PDF_x1 = 0.5*(X1_edges(1:end-1) + X1_edges(2:end));
    PDF_x2 = 0.5*(X2_edges(1:end-1) + X2_edges(2:end));
    
    PDF_y(N'==0)=NaN;

end