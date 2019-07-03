%kldiv test

load SOM_eps1

a1=reshape(ww{1},204*9,1);
a1=a1-min(a1);
a1=a1/max(a1);
a2=reshape(ww{2},204*9,1);
a2=a2-min(a2);
a2=a2/max(a2);
a3=reshape(ww{3},204*9,1);
a3=a3-min(a3);
a3=a3/max(a3);
a4=reshape(ww{4},204*9,1);
a4=a4-min(a4);
a4=a4/max(a4);
a5=reshape(ww{5},204*9,1);
a5=a5-min(a5);
a5=a5/max(a5);
sumall=0;
a1=a5/sum(a5);
a2=a4/sum(a4);
plot((log2(a1)-log2(a2)))
for i=1:length(a1)
    if a1(i)==0||a2(i)==0
        a1(i)=1;
        a2(i)=1;
    end
    sumall=sumall+((a1(i))*(log2(a1(i))-log2(a2(i))));
end
sumall