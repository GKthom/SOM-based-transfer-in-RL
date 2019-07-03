function [d]=dist_meas(S,stats,method)
% Finds distance between sensor measurement and mean of some cluster
st_mat=(stats);
if method=='eucl'
    d_vect=S-st_mat(:,1);
    d=sqrt(sum(d_vect.^2));
% elseif method=='maha'
%     S
%     st_mat(:,1)
%     cov(S,st_mat(:,1))
%     d=sqrt((S-st_mat(:,1))*cov(S,st_mat(:,1))*(S-st_mat(:,1))');
end