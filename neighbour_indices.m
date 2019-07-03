function [fin_neighs]=neighbour_indices(ind,nsom)

d=reshape(1:nsom,sqrt(nsom),sqrt(nsom));
[r c]=find(d);
rw=r(ind);
cw=c(ind);


neighs=[rw-1 cw-1;rw-1 cw;rw-1 cw+1;rw cw-1;rw cw+1;rw+1 cw-1;rw+1 cw;rw+1 cw+1];
s_n=size(neighs);
newneighs=[];
for i=1:s_n(1)
    if neighs(i,1)<=0||neighs(i,1)>sqrt(nsom)||neighs(i,2)<=0||neighs(i,2)>sqrt(nsom)
    else
        newneighs=[newneighs;neighs(i,:)];
    end
end
s_n=size(newneighs);
for i=1:s_n(1)
    fin_neighs(i)=d(newneighs(i,1),newneighs(i,2));
end