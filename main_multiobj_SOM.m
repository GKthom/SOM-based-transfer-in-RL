%main file for 'storage and transfer of knowledge using self-organizing
%maps' (ALA workshop, FAIM, 2018)
%author: Thommen George Karimpanal
%Last modified: Feb, 2018
clear
close all
clc
try
ret_prim=[];%return log for primary task
p=parameters();
returns_all={};%initialize returns history
clusters_all={};%initialize clusters history
for k=1:p.N_runs%number of runs
k
returns{1}=[];
state=p.start;
feats=featsfromstate(state,p);%get features from state
w_prim=rand(length(feats),p.A);%primary task
ww={};
ww{1}=rand(length(feats),p.A);
%%%%Initialize clusters and reward list%%%%
clusters={};
[clusters]=k_means(feats(1:p.reward_inds),clusters,p);
clust_form=[];
nsom=p.N_SOM;
SOM=rand((length(feats))*p.A,nsom);
%Learn primary objective (p.target) first. During learning, note if any new
%clusters. (refer: https://www.sciencedirect.com/science/article/pii/S0925231217311001) 
%If so, learn them sequentially. Repeat while learning secondary
%objectives as well

%Keep prim task as the first task to learn (ww{1}) and then check length of
%ww to see if it has changed. If so, move to the next ww{i}
task_ind=0;

    WI1=[];
    WI2=[];
    WI3=[];
    WI4=[];
    WI5=[];
    WI6=[];
    WI7=[];

while task_ind<=length(ww)
    task_ind
    if task_ind==0
        w=w_prim;%primary task
        prim_feats=featsfromstate(p.target,p);
        goal=prim_feats(1:p.reward_inds);%goal for primary task
    else
        w=ww{task_ind};
        goal=round(clusters{task_ind}(:,1));%goal for auxilliary tasks
    end
rej=[];

for i=1:p.N_iter
    i
    p=parameters();
    n_clusters_prev=length(clusters);%initial number of clusters
    [w,clusters,wi]=Q_learn_clustering(SOM,p,goal,clusters,w);%Qlearning
    n_clusters_new=length(clusters);%final number of clusters
    if n_clusters_new>n_clusters_prev%if there are new clusters, initialize their corresponding value function weights
        for nc=(n_clusters_prev+1):n_clusters_new%initialize Q values of new cluster as zeros
            ww{nc}=rand(length(feats),p.A);%initialize VF weights
            returns{nc}=[];%initialize return log
        end
    end
    retj(i)=0;%calcretfeats(w,p,goal);%calculate returns greedily

if task_ind==1
    WI1=[WI1;wi];
elseif task_ind==2
    WI2=[WI2;wi];
elseif task_ind==3
    WI3=[WI3;wi];
elseif task_ind==4
    WI4=[WI4;wi];
elseif task_ind==5
    WI5=[WI5;wi]; 
elseif task_ind==6
    WI6=[WI6;wi];
elseif task_ind==7
    WI7=[WI7;wi]; 
end
end
%%%%%%%%%%%Returns-comment out till line 73 to stop tracking returns and speed up code%%%%%%%%%%%%%%%%%%%
%%%%%for primary task%%%%%%%%%
if task_ind==0
    ret_prim=[ret_prim;retj];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%for auxilliary tasks%%%
if task_ind>0
    ww{task_ind}=w;
    %%%%%%%%Evaluate returns%%%%%%%
    returns{task_ind}=[returns{task_ind};retj];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%Call SOM%%%%%%%%%%
if task_ind==0
    ips={w_prim};%primary task
else s_SOM=size(SOM);
    newxx={};
    for j=1:s_SOM(2)
        newxx{j}=SOM(:,j);%SOM node weights
    end
    ips=[newxx ww{task_ind}]; %use SOM nodes as inputs to the SOM for subsequent iterations
end
[SOM]=GSOM_add_new(SOM,ips,p);%update knowledge base using SOM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
task_ind=task_ind+1;
end
returns_all{k}=returns;
clusters_all{k}=clusters;
% log_sim_all{k}=log_sim;
end
%hallelujah!
load handel
sound(y,Fs)

catch err
    a=err.message
    b=err.stack
    keyboard
end

%%%%%%Compile Evaluations%%%%%%
[returnscoop]=scoopdy(clusters_all, returns_all, p);