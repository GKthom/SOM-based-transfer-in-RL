function [out]=within_range(stats,S,std_dev_tol)
%Check whether a sensor measurement is within statistically close to a
%cluster within some tolerance
flag_vect=sum(abs(S-stats(:,1))<std_dev_tol*(stats(:,2)));
% if flag_vect>0
if flag_vect==length(stats(:,1))%if all features lie within n std deviations of their mean value
    out=1;%Dont seed a new cluster
else out=0;%seed a new cluster
end