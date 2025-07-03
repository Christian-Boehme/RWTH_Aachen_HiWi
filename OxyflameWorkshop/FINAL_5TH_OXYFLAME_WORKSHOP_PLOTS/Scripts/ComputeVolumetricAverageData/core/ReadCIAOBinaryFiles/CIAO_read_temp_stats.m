function [stats_spatial]=CIAO_read_stats(prefix,var,file_freq,number_first,number_last,apply_sym)
%
% This script reads spatial statics of a temporally evolving jet
ind=number_first:file_freq:number_last;
for i=1:size(ind,2)
    [stats_spatial_tmp]=read_real(strcat(prefix,sprintf('%06d',ind(i))),var);
    if (apply_sym )
        stats_spatial(i,1:size(stats_spatial_tmp,1)/2)=...
            0.5*(stats_spatial_tmp(size(stats_spatial_tmp,1)/2:-1:1)+...
            stats_spatial_tmp(1+size(stats_spatial_tmp,1)/2:size(stats_spatial_tmp,1)));
    else
        stats_spatial(i,:)=stats_spatial_tmp;
    end
end
