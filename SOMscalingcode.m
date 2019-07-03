clear
load SOM1000tasks
for i=1:1000
    wwall{i}=ww{randi(10)};
end
% wwall=ww;

tsks=[5;10;50;100;250;500;750;1000];
somlog=[];
p.SOM_iter=300;
% % % % for k=1:10
% % % %     tskSOMsize=[];
% % % %     SOM=[];
% % % % for t=1:length(tsks)
% % % %     t
% % % % %     SOM=[];
% % % %     w={};
% % % %     for i=1:tsks(t)
% % % % %         w{i}=wwall{randi(length(wwall))};
% % % %         w{i}=wwall{randi(tsks(t))};
% % % %     end
% % % %     SOM=GSOM_add_new(SOM,w,p);
% % % %     s_SOM=size(SOM);
% % % %     tskSOMsize(t)=s_SOM(2);
% % % % end
% % % % somlog=[somlog;tskSOMsize];
% % % % beep
% % % % end
% % % % % plot(tsks,tskSOMsize)
somlogall={};
for k=1:10
    SOM=[];
for tasks=1:length(ww)
    k
    tasks
if tasks==1
    ips={ww{1}};
else s_SOM=size(SOM);
    newxx={};
    for j=1:s_SOM(2)
        newxx{j}=SOM(:,j);
    end
    ips=[newxx ww{randi(length(ww))}]; 
end
[SOM]=GSOM_add_new(SOM,ips,p);
s_SOM=size(SOM)
if s_SOM(2)<tasks
    disp('S!');
end
somlog=[somlog;s_SOM(2)];
end
somlogall{k}=somlog;
end