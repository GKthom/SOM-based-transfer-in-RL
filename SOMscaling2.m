load SOM1000tasks
tsks=[5;10;50;100;250;500;750;1000];
somlog=[];
p.SOM_iter=25;
for k=1:10
    tskSOMsize=[];
for t=1:length(tsks)
    SOM=[];
    w={};
    for i=1:tsks(t)
        w{i}=ww{i};
    end
    SOM=GSOM_add(SOM,w,p);
    s_SOM=size(SOM);
    tskSOMsize(t)=s_SOM(2);
end
somlog=[somlog;tskSOMsize];
end
% plot(tsks,tskSOMsize)