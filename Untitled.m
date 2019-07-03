 SOMID=[];
for i=1:100
for j=1:30
d(j)=norm(SOM(:,i)-reshape(ww{j},1800,1));
mind=min(d);
end
SOMID=[SOMID;find(d==mind)];
end