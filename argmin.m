function [min_arg]=argmin(vector)
%Find min argument of a vector
min_arg=find(vector==min(vector));
if length(min_arg)>1
    min_arg=min_arg(randi(length(min_arg)));
end