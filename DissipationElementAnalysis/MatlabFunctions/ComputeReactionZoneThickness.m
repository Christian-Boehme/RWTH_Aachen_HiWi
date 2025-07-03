function dZr = ComputeReactionZoneThickness(w, Z)

    % max heat-release
    [wmax_val, wmax_idx] = max(w);
    
    % second gradient
    if wmax_idx ~= length(w)
        % dZ = Z(wmax_idx + 1) - Z(wmax_idx);
        % "ensure" to have an equidistant grid
        dZp = Z(wmax_idx+1) - Z(wmax_idx);
        dZm = Z(wmax_idx) - Z(wmax_idx-1);
        dwdZ_sec = 2 .* (dZm .* w(wmax_idx+1) - (dZm + dZp) .* ...
            w(wmax_idx) + dZp .* w(wmax_idx-1)) ./ ((dZm + dZp) .* ...
            ( dZm .* dZp));
    else
        % max point at the end
        fprintf(['Max at end -> finite difference at boundary for ' ...
            'case: %s\n'] ,c);
        return
    end

    % reaction zone thickness (Niemietz 2024)
    dZr = 2 * (-2 * log(2) * wmax_val * (dwdZ_sec)^(-1))^(0.5);
    %fprintf('Reaction zone thickness = %e\n', dZr);

end
