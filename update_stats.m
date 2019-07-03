function [stats]=update_stats(stats,S,init_var)
%Updates mean and variance of cluster as and when data comes in
if length(stats)==0
    stats=[S init_var*ones(length(S),1) ones(length(S),1)];%initialize cluster stats
else
    s=size(stats);
    for i=1:s(1)
        u(i)=(stats(i,3)*stats(i,1)+S(i))/(stats(i,3)+1);%mean
        sigma_sq(i)=((stats(i,3)*(stats(i,2)+(stats(i,1))^2)+(S(i))^2)/(stats(i,3)+1))-(u(i))^2;%variance
    end
    sig=sqrt(sigma_sq);
    stats=[u' sig' stats(:,3)+1];%update stats
end