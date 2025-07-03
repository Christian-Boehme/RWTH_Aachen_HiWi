function [id, x_pos,y_pos,z_pos] = DE_GetGridPoints(arr)

    % dissipation element id
    id = arr(1);

    % x-position
    x_indices = 2:3:length(arr);
    x_pos = arr(x_indices);

    % y-position
    y_indices = 3:3:length(arr);
    y_pos = arr(y_indices);

    % z-position
    z_indices = 4:3:length(arr);
    z_pos = arr(z_indices);

    % clipp all elements equal zero
    x_pos = x_pos(x_pos ~= 0);
    y_pos = y_pos(y_pos ~= 0);
    z_pos = z_pos(z_pos ~= 0);

end
