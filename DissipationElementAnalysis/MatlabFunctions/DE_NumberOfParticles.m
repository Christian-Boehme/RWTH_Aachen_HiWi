function [n_prt, coord] = DE_NumberOfParticles(x, y, z, x_prt_pos, y_prt_pos, ...
    z_prt_pos, dx, nx, ny, nz)

    %
%     prt_pos = readtable(nd, 'VariableNamingRule', 'preserve');
%     x_prt_pos = prt_pos.Points_0;
%     y_prt_pos = prt_pos.Points_1;
%     z_prt_pos = prt_pos.Points_2;

    n_prt = 0;
    coord = zeros(length(x), 1);
    for i = 1:length(x_prt_pos)
        for j = 1:length(x)
            %disp(dx*(x(j) - nx/2));
            if (x_prt_pos(i) - dx/2 <= dx*(x(j) - nx/2)) && ( ...
                    x_prt_pos(i) + dx/2 >= dx*(x(j) - nx/2))
                %disp(x(j));
                if (y_prt_pos(i) - dx/2 <= dx*(y(j) - ny/2))  && ( ...
                        y_prt_pos(i) + dx/2 >= dx*(y(j) - ny/2))
                    %disp(y(j));
                    if (z_prt_pos(i) - dx/2 <= dx*(z(j) - nz/2))  && ( ...
                            z_prt_pos(i) + dx/2 >= dx*(z(j) - nz/2))
                        n_prt = n_prt + 1;
                        coord(j) = 1;
%                         fprintf('\nParticle: x=%i, y=%i, z=%i', ...
%                             x_prt_pos(i), y_prt_pos(i), z_prt_pos(i));
                    end
                end
            end
        end
    end

end
