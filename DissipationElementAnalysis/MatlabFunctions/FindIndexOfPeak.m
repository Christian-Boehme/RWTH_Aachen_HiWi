function i_max = FindIndexOfPeak(w)

    % modifiy data
    [pks,pks(:,2),pks(:,3),pks(:,4)] = findpeaks(w, 'sortstr', 'descend');
    pks(:,5) = pks(:,4)./pks(:,1);
    pks(:,6) = pks(:,3)./pks(:,1);
    
%     if isempty(pks)
%         DeltaZ{i} = nan;
%         continue;
%     end
    
    if size(pks,1) > 1
        disp(pks(:,5));
        disp(pks(:,2));
        for i = 1:length(pks(:,5))
            idx = pks(:,2);
            disp(idx);
            fprintf('\nPeak %i: w=%e', i, w(idx));
        end
        % Remove peaks where the ratio of prominence/height < 0.5
        pks((pks(:,5)<0.5),:) = [];
        % Remove peaks whos height is less than 10% of max peak height
        pks((pks(:,1)<0.2*max(pks(:,1))),:) = [];
        % Remove peak
        pks((pks(:,3)~=min(pks(:,3))),:) = [];
    end
    
    i_max = pks(:,2);
    fprintf('\nThis script must be modified!');
    return
%     if length(i_max) ~= 1
%         fprintf('\nMore than one peak detected!\n -> Modify conditions!');
%         return
%     end
%     disp(pks);
%     disp(pks(:,3));
%     disp(pks(:,4));
%     if length(i_max) >= 1
%         fprintf('\nPeak 1: Z=%e, w=%e\n', Z(i_max(1)), w(i_max(1)));
%     end
%     if length(i_max) >= 2
%         fprintf('Peak 2: Z=%e, w=%e\n', Z(i_max(2)), w(i_max(2)));
%     end
%     if length(i_max) >= 3
%         fprintf('Peak 3: Z=%e, w=%e\n', Z(i_max(3)), w(i_max(3)));
%     end

end
