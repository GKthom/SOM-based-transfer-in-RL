clear
close all
clc
try
ret_prim=[];
p=parameters();
returns_all={};
clusters_all={};
for k=1:p.N_runs
k
returns{1}=[];
state=p.start;
feats=featsfromstate(state,p);
w_prim=rand(length(feats),p.A);
ww={};
ww{1}=rand(length(feats),p.A);
%%%%Initialize clusters and reward list%%%%
clusters={};
[clusters]=k_means(feats(1:p.reward_inds),clusters,p);
clust_form=[];
nsom=p.N_SOM;
SOM=rand((length(feats))*p.A,nsom);
%Learn primary objective (p.target) first. During learning, note if any new
%clusters. If so, learn them sequentially. Repeat while learning secondary
%objectives as well

%Keep prim task as the first task to learn (ww{1}) and then check length of
%ww to see if it has changed. If so, move to the next ww{i}
task_ind=0;

while task_ind<=length(ww)
    task_ind
    if task_ind==0
        w=w_prim;
        prim_feats=featsfromstate(p.target,p);
        goal=prim_feats(1:p.reward_inds);
    else
        w=ww{task_ind};
        goal=round(clusters{task_ind}(:,1));
    end
rej=[];
for i=1:p.N_iter
    i
    p=parameters();
    n_clusters_prev=length(clusters);
    [w,clusters]=Q_learn_clustering_3explore(SOM,p,goal,clusters,w,i);%weights and goals need to be chosen
    n_clusters_new=length(clusters);    
    if n_clusters_new>n_clusters_prev
        for nc=(n_clusters_prev+1):n_clusters_new%initialize Q values of new cluster as zeros
            ww{nc}=rand(length(feats),p.A);
            returns{nc}=[];
        end
    end
    retj(i)=calcretfeats(w,p,goal);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if task_ind==0
    ret_prim=[ret_prim;retj];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if task_ind>0
    ww{task_ind}=w;
    %%%%%%%%Evaluate returns%%%%%%%
    returns{task_ind}=[returns{task_ind};retj];
end

%%%%%%%%%Call SOM%%%%%%%%%%
if task_ind==0
    ips={w_prim};
else s_SOM=size(SOM);
    newxx={};
    for j=1:s_SOM(2)
        newxx{j}=SOM(:,j);
    end
    ips=[newxx ww{task_ind}]; 
end
[SOM]=GSOM_add_new(SOM,ips,p);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
task_ind=task_ind+1;
end
returns_all{k}=returns;
clusters_all{k}=clusters;
end
load handel
sound(y,Fs)

catch err
    a=err.message
    b=err.stack
    keyboard
end

%%%%%%Compile Evaluations%%%%%%
[returnscoop]=scoopdy(clusters_all, returns_all, p);