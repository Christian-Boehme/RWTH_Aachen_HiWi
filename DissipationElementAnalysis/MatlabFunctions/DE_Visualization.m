function a = DE_Visualization(id, data, num, cvar, cdata, approach, ...
    msize, FZ, ofname, sim_case, FigFormat)

    % extract data
    [DE_id, x_coords, y_coords, z_coords] = DE_GetGridPoints(data(:,num));

    % check
    if id ~= DE_id
        fprintf('\nIncorrect dissipation element detected!');
        return
    end

    % get corresponding data points in dissipation element
    cb_var = DE_ExtractData(cdata, x_coords, y_coords, z_coords);

    % colorbar data
    switch(cvar)
        case 'Chi'
            cblabel = '$\chi$ [1/s]';
            lowLim = 0;
            upLim = max(cb_var);
        case 'Cp'
            cblabel = '$c_\mathrm{p}$ [kJ/kg]';       % TODO correct??
            lowLim = 0;
            upLim = max(cb_var);
        case 'Enth'
            cblabel = '$H$ [kJ/kg]';                % TODO correct??
            lowLim = min(cb_var);
            upLim = max(cb_var);
        case 'HR'
            cblabel = '$\omega_\mathrm{T}$ $\mathrm{[J/m^{3}/s]}$';
            lowLim = 0;
            upLim = max(cb_var);
        case 'Lambda'
            cblabel = '$\lambda$ [-]';
            lowLim = 0;
            upLim = max(cb_var);
        case 'PV'
            cblabel = '$PV$ [-]';
            lowLim = 0;
            upLim = max(cb_var);
        case 'PVnorm'
            cblabel = '$PV_\mathrm{norm}$ [-]';
            lowLim = 0;
            upLim = max(cb_var);
        case 'Rho'
            cblabel = '$\rho$ $\mathrm{[kg/m^{3}]}$';
            lowLim = 0;
            upLim = max(cb_var);
        case 'Tgas'
            cblabel = '$T_\mathrm{gas}$ [K]';
            lowLim = 0;
            upLim = max(cb_var);
        case 'YOH'
            cblabel = '$Y_\mathrm{OH}$ [-]';
            lowLim = 0;
            upLim = max(cb_var);
        case 'Zmix'
            cblabel = '$Z_\mathrm{mix}$ [-]';
            lowLim = 0;
            upLim = max(cb_var);
        otherwise
            fprintf('\nInvalid variable name: %s', cvar);
            return
    end

    
    % create 3D figure of dissipation element
    close all
    figure
    t = tiledlayout(1,1);
    t.TileSpacing = 'compact';
    t.Padding = 'loose';                                                                                                                                                                                                                      
    nexttile([1, 1]);
    set(gcf,'color','w');


    % plot
    if strcmp(approach, 'Scatter')
        scatter3(x_coords, y_coords, z_coords, msize, cb_var, ...
            'filled');
    elseif strcmp(approach, 'Surface')
        [Xq, Yq] = meshgrid(linspace(min(x_coords), max(x_coords), ...
            300), linspace(min(y_coords), max(y_coords), 300));
        Zq = griddata(x_coords, y_coords, z_coords, Xq, Yq, 'cubic');
        cbq = griddata(x_coords, y_coords, cb_var, Xq, Yq, 'cubic');
        surf(Xq, Yq, Zq, 'CData', cbq, 'FaceColor', 'interp', ...
            'EdgeColor', 'none');
    elseif strcmp(approach, 'Trajectories')
        %
        a = 0;
    else
        fprintf(['\nInvalid visualization approach (%s)\n => Scatter/' ...
            'Surface/Trajectories\n'], approach);
        return
    end


    % colorbar
    colormap(jet);
    caxis([lowLim, upLim]);
    cb = colorbar('eastoutside');
    cb.TickLabelInterpreter = 'latex';
    cb.FontName = 'Times';
    %cb.FontWeight = ax.FontWeight;
    cb.FontSize = FZ-5;
    ylabel(cb, cblabel, 'fontsize', FZ, ...
        'interpreter', 'latex', 'FontWeight', 'bold');


    % labels and title
    xlabel('x', 'fontsize', FZ, 'interpreter', 'latex', ...
        'FontWeight', 'bold');
    ylabel('y', 'fontsize', FZ, 'interpreter', 'latex', ...
        'FontWeight', 'bold');
    zlabel('z', 'fontsize', FZ, 'interpreter', 'latex', ...
        'FontWeight', 'bold');
    
        
    % format
    set(gca, 'Box', 'on');


    % figure name
    ofname = strcat(ofname, 'DE', 'Case_', sim_case, ...
        '_DEid_', num2str(DE_id), '_Variable_', cvar);

    
    % save figure
    if strcmp(FigFormat, 'png')
        saveas(gca, strcat(ofname, '.png'), 'png');
    elseif strcmp(FigFormat, 'eps')
        saveas(gca, strcat(ofname, '.eps'), 'epsc');
    elseif strcmp(FigFormat, 'pdf')
        exportgraphics(gca, strcat(ofname, '.pdf'), ...
            'ContentType', 'vector');
    else
        fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
            FigFormat);
        return
    end

end
