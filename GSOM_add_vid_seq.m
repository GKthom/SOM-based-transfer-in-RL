%implementation of the growing self-organizing map
function [SOM,SOMout]=GSOM_add_vid_seq(SOM,ww,www,clusters,p,seq_no)
h=figure;
movegui(h, 'onscreen');
title('test')
vidObj = VideoWriter(strcat('meh',num2str(seq_no)));
vidObj.Quality = 100;
open(vidObj);

s_ww=size(ww{1});
for i=1:length(ww)
    x(:,i)=reshape(ww{i},s_ww(1)*s_ww(2),1);%turn all the stored weights into column vectors
end

s_x=size(x);
s_SOM=size(SOM);
if s_SOM(2)<=p.N_SOM
w=rand(s_x(1),p.N_SOM);%random initialization of the SOM
errs=zeros(p.N_SOM,1);%errors corresponding to each SOM element
E=0;%sum of errs
nsom=p.N_SOM;%number of SOM elements
else 
w=SOM;
errs=zeros(s_SOM(2),1);%errors corresponding to each SOM element
E=0;%sum of errs
nsom=s_SOM(2);%number of SOM elements
end

for n=1:p.SOM_iter
n
E_old=E;

% for i=1:s_x(2)    %go through all the weight vectors
for ii=1:s_x(2)
    i=randi(s_x(2));
    cos_sim=[];
    for t=1:nsom
        cos_sim(t)=((x(:,i))'*(w(:,t)))/norm(x(:,i))/norm(w(:,t));%find similarity b/w stored weights and SOM elements
    end
    maxsim=max(cos_sim);%%max of those similarities
    a=find(cos_sim==maxsim);%index of max similarity
    if length(a)>1
        a=a(randi(length(a)));
    end
    errs(a)=errs(a)+1-cos_sim(a);%store error as the distance measure corr to this neuron
    
%%%%%%%%%%index of winner neuron%%%%%%%%%
Neu=1:nsom; %%%%dummy matrix 
d=reshape(Neu,sqrt(nsom),sqrt(nsom));%%dummy 
[r c]=find(d);
rw=r(a);% row index of winner
cw=c(a);% column index of winner


%%update weights%%%%%%%%%%
for j=1:nsom
    rl=r(j);%row index of 'loser' neurons
    cl=c(j);%column index of 'loser' neurons
    dji=sqrt((rw-rl)^2+(cw-cl)^2); %distance between the winner and the current neuron   
    Zo=50; %%%%sigma0
    tau1=1000/log(Zo);
    etao=0.1;
    eta=etao*exp(-(n-1)/1000);
    Z=Zo*exp(-(n-1)/tau1);%sigma
    hji=exp(-(dji^2)/(2*(Z^2)));
    w(:,j)=w(:,j)+eta*hji*((x(:,i))-(w(:,j)));%SOM weight update
end  

end

    E=sum(errs);
    if (E-E_old)/length(errs)>0.3%Growth threshold
%         (E-E_old)/(1-cos_sim(a))
        %create new neuron
        gsom_inds=ones(sqrt(nsom),sqrt(nsom));
        errs=reshape(errs,sqrt(nsom),sqrt(nsom));
        errs=[errs zeros(sqrt(nsom),1)];%add column
        gsom_inds=[gsom_inds zeros(sqrt(nsom),1)];%add column
        nsom=(sqrt(nsom)+1)^2;%increase nsom
        errs=[errs;zeros(1,(sqrt(nsom)))];%add row
        gsom_inds=[gsom_inds;zeros(1,(sqrt(nsom)))];%add row        
        gsom_inds=reshape(gsom_inds,sqrt(nsom),sqrt(nsom));
        errs=reshape(errs,nsom,1);
        %Find indices of w and initialize it to the avg of their
        %neighbours.
        new_inds=find(gsom_inds==0);
        
%         insert = @(a, x, n)cat(2,  x(:,1:n), a, x(:,n+1:end));
        %create a wnew-elements of the new SOM with new SOM elements set to zero
        wnew=zeros(s_x(1),nsom);%weight vector copy
        cnt=1;
        for ii=1:nsom
            if gsom_inds(ii)==1
                wnew(:,ii)=w(:,cnt);
                cnt=cnt+1;                
            end
        end
        %%%%%%%%%%%%
        %Go through the new indices
        for ii=1:length(new_inds)
            neighs=neighbour_indices(new_inds(ii),nsom);%find neighbours
            meanwts=zeros(s_x(1),1);
            co=0;
            for jj=1:length(neighs)%mean of neighbours
                if length(find(neighs(jj)==new_inds))==0%if a neighbour is not a new index
                    meanwts=meanwts+wnew(:,neighs(jj));
                    co=co+1;%count number of non zero neighbours
                end
            end
            wnew(:,new_inds(ii))=meanwts/co;
        end
       w=wnew; 
    end


[SOMout,SOMres]=plotSOMcolors_vid_seq(w,www,clusters,p);
h=image(SOMout);
%axis([0 8 0 8])%for Gt=0.1 use 8, for 0.05 use 11
% set(gca,'YTick',[])
% set(gca,'XTick',[])
%text(5,1,strcat('Iteration Number=',num2str(n)));%for Gt=0.1 use 5, for 0.05 use 7
pause(0.001)
hold off
movegui(h, 'onscreen');
drawnow;
currFrame = getframe;
writeVideo(vidObj,currFrame);


if n/p.SOM_iter==0.25
    disp('25%')
elseif n/p.SOM_iter==0.5
    disp('50%')
elseif n/p.SOM_iter==0.75
    disp('75%')
elseif n/p.SOM_iter==1
    disp('100%')   
end
end

SOM=w;
close(vidObj);