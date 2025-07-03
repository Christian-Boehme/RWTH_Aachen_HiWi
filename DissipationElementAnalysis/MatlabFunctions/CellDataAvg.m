function [x_data, avg_data,std_data] = CellDataAvg(X,Y,n,X_lim,type,sf,factor)
    % X = Column Vector
    % Y = Column Vector
    % n = Maximum number of Conditional Mean Points; Note that the function
    % would not return the same number of points as there are come cells which
    % may have no data points
    % xlim = Entered in Format [lower limit of X, higher limit of X] --- limit from maximum to minimum for which conditional mean is
    % required, this limit may be trimmed for places where data is sparse
    % type == possible values 1 or else(e.g. 0) if type == 1, the program will
    % automatically determine if the data is sparse at some points and will not
    % include those points in the output. This is usefull for plotting,
    % especially DNS data and autmatic adjustments while plottting many plots
    % and plotting automation. Note that in case, type == 1, the xlim should be given as following input xlim = [min(X), max(X)]
    % sf = smoothing factor based on number of points in the input; use around 0.05 for good result ( emperical test)
    % --- May need to Change upon use ----------
    %factor = 0.00005;
    % -- factor is related to type, the program will ignore any cells with
    % value count less than 'factor x n'
    
    
    xy = sortrows([X, Y],1);
    X = xy(:,1);
    Y = xy(:,2);
    
    div = min(X):(max(X)-min(X))/n:max(X);
    %div = logspace(log10(min(X)),log10(max(X)),n+1);
    
    s1 = max(size(X),[],'all');
    for i = 1:n
        count = 1;
        index_list = [];
        for j = 1:s1
            if X(j)>=div(i) && X(j)<=div(i+1)
                index_list(count) = j;
                count = count + 1;
            end
        end
        if count < round(factor*s1) && type == 1 % For Field plots
            x_data(i,1) = NaN;
            avg_data(i,1) = NaN;
            std_data(i,1) = NaN;
        else
            x_data(i,1) = (div(i) + div(i+1))/2;
            avg_data(i,1) = mean(Y(index_list));
            std_data(i,1) = std(Y(index_list));
         end
    end
    data = [x_data,avg_data,std_data];
    data = data((~isnan(data(:,1)) & ~isnan(data(:,2)) & ~isnan(data(:,3))),:);
    
    % data clipping on X axis
    data = data(data(:,1)>=X_lim(1),:);
    data = data(data(:,1)<=X_lim(2),:);
    
    x_data = data(:,1);
    avg_data = data(:,2);
    std_data = data(:,3);
    
    avg_data = smooth(x_data,avg_data,n*sf);
    std_data = smooth(x_data,std_data,n*sf);
end