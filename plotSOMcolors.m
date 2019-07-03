function [SOMout,SOMres]=plotSOMcolors(SOM,ww,clusters,p)

s=size(SOM);
sww=size(ww{1});
for i=1:(s(2))
    for k=1:length(ww)
        wwtemp=reshape(ww{k},sww(1)*sww(2),1);
        d(k)=wwtemp'*SOM(:,i)/norm(SOM(:,i))/norm(wwtemp);
    end
    task=find(d==max(d));
    if length(task)>1
        task=task(randi(length(task)));
    end
    SOMres(i,:)=[task max(d)];
end
s_SOMres=size(SOMres);


for i=1:s_SOMres(1)
Neu=1:s(2); 
dd=reshape(Neu,sqrt(s(2)),sqrt(s(2))); 
[r c]=find(dd);
rw=r(i);% row index of winner
cw=c(i);% column index of winner    
if SOMres(i,1)==1
    col=[0 0 0];%'k'
elseif SOMres(i,1)==2
    col=[0 0 1];%'b'
elseif SOMres(i,1)==3
    col=[0 1 0];%'g'
elseif SOMres(i,1)==4
    col=[0 1 1];%'c'cyan
elseif SOMres(i,1)==5
    col=[1 0 0];%'r'
elseif SOMres(i,1)==6
    col=[1 0 1];%magenta
elseif SOMres(i,1)==7
    col=[1 1 0];%yellow
elseif SOMres(i,1)==8
    col=[1 1 1];%white
end
% % % f=find(col==0);
% % % if length(f)>0
% % % col(f(1))=SOMres(i,2);
% % % else col(1)=SOMres(i,2);
% % % end
% % % SOMout(rw,cw,1:3)=col;
SOMout(rw,cw,1:3)=col*(SOMres(i,2));
end

figure
set(gca,'XTick',[0:10:30],'fontsize',12)
set(gca,'YTick',[0:10:30],'fontsize',12)
axis([0 30 0 30])
hold on
count=0;
for i=1:p.a
    for j=1:p.b
        if p.world(i,j)==1
        scatter(i,j,'k','filled');
        hold on
        end
    end
end



for i=1:length(SOMres)

if SOMres(i,1)==1
    col=[0 0 0];%'k'
elseif SOMres(i,1)==2
    col=[0 0 1];%'b'
elseif SOMres(i,1)==3
    col=[0 1 0];%'g'
elseif SOMres(i,1)==4
    col=[0 1 1];%'c'cyan
elseif SOMres(i,1)==5
    col=[1 0 0];%'r'
elseif SOMres(i,1)==6
    col=[1 0 1];%magenta
elseif SOMres(i,1)==7
    col=[1 1 0];%yellow
elseif SOMres(i,1)==8
    col=[1 1 1];%white
end    
    
clust=clusters{SOMres(i,1)};
%get postn by checking cluster feats and scatter with corresponding color
if sum(round(clust(:,1))==[0;0;0;0])==p.reward_inds
    pos=[p.a,p.b];
elseif sum(round(clust(:,1))==[0;0;0;1])==p.reward_inds
    pos=p.target4;
elseif sum(round(clust(:,1))==[0;0;1;0])==p.reward_inds
    pos=p.target3;
elseif sum(round(clust(:,1))==[0;1;0;0])==p.reward_inds
    pos=p.target2;
elseif sum(round(clust(:,1))==[1;0;0;0])==p.reward_inds
    pos=p.target;
elseif sum(round(clust(:,1))==[1;0;0;1])==p.reward_inds
    pos=(p.target+p.target4)/2;
elseif sum(round(clust(:,1))==[0;1;1;0])==p.reward_inds
    pos=(p.target2+p.target3)/2;
end
hold on
scatter(pos(1),pos(2),500,'MarkerEdgeColor',col,...
              'MarkerFaceColor',col,...
              'LineWidth',1.5)
end

figure
grid on
image(SOMout)
set(gca,'XTick',[1:1:8],'fontsize',12)
set(gca,'YTick',[1:1:8],'fontsize',12)

for i=1:s_SOMres(1)
    Neu=1:s(2); 
    dd=reshape(Neu,sqrt(s(2)),sqrt(s(2))); 
    [r c]=find(dd);
    rw=r(i);% row index of winner
    cw=c(i);% column index of winner   
    rw
    cw
    resx=10.4*sqrt(s(2))/8;
    resy=9.85*sqrt(s(2))/8;
    dim = [0.13+(rw-1)/resx 0.11 0.775 0.815-(cw-1)/resy];%[rw/(res) cw/(1.05*res) 0.1 0.1];
    str = num2str(round(SOMres(i,2),3));
    annotation('textbox',dim,'String',str,'LineStyle','none');%,FitBoxToText','on');
end