function [x_fit, y_fit] = Flamelets_GaussianCurveFitting(x, y)

    % maximum point
    [max_y, max_idx] = max(y);
    x_max = x(max_idx);
    
    % left and right points around the peak
    if max_idx > 1 && max_idx < length(x)
        x_left = x(max_idx - 1);
        y_left = y(max_idx - 1);
        x_right = x(max_idx + 1);
        y_right = y(max_idx + 1);
    else
        error('Peak is at the boundary. Cannot fit data!');
    end
    
    % estimate standard deviation (sigma) using distances from the peak
    % assuming Gaussian drop-off is symmetric
    sigma = (abs(x_max - x_left) + abs(x_right - x_max)) / 2;
    
    % gaussian function
    gaussian = @(x) max_y * exp(-((x - x_max).^2) / (2 * sigma^2));
    
    % generate smooth x values for Gaussian plot
    tot = length(x);
    x_fit = linspace(min(x), max(x), tot);
    y_fit = gaussian(x_fit);

end
