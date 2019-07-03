function [w,avgret,SOMadvice]=Q_learnfromSOM_explore(SOM,goal,p)

feats=featsfromstate(p.start,p);
w=rand(length(feats),p.A);
avgret=[];
b=0;
mem_ind=randi(3);
exp_const=log(p.min_SOM_update)/(-p.N_iter);%So that even at i=p.N_iter, the probability of getting SOM advice diminishes to p.min_SOM_update
SOMadvice=[];
%%%%%%%Check which SOM is closest to these wts and learn from them with Q-learning%%%%%%
for i=1:p.N_iter
    i    
    w=reshape(w,length(feats)*p.A,1);%reshape into a vector
    s_som=size(SOM);
    for j=1:s_som(2)
        d(j)=w'*SOM(:,j)/norm(SOM(:,j))/norm(w);%go through all the SOMs and calculate cosine similarity b/w w and SOMs
    end
    win_ind=find(d==max(d));%most similar SOM index
    if length(win_ind)>1
        win_ind=win_ind(randi(length(win_ind)));
    end
    beta=max(d);%/sqrt(i);%similarity metric- between 0 and 1
    fbeta=1/(1+exp(-p.squashparam*(beta-p.transfer_thresh)));%fbeta is >0.5 only if beta is more than the threshold
%     w=w*(1-fbeta)+fbeta*(SOM(:,win_ind));  
    w=reshape(w,length(feats),p.A); 
    e=zeros(length(feats),p.A);
    avgret=[avgret;calcret(w,p,goal)];
    count=0;
    p=parameters();
    state=p.start;
    while norm(state(1:2)-goal)>p.target_thresh
        
    probs=[0.1 0.7 fbeta*exp(-i*exp_const)];%/sqrt(sqrt(sqrt(i)))];%/sqrt(i)];%random,greedy,SOMbased- more the 
%     probs=[0.7 0.3];%/sqrt(sqrt(sqrt(i)))];%/sqrt(i)];%random,greedy,SOMbased
    [mem_ind,b]=selectsample(probs,mem_ind,b);%probability proportional selection
%     if mem_ind==1
%         a=randi(p.A);
%     elseif mem_ind==2
%         [a, Qmax]=maxQ(state,w,p);
%     elseif mem_ind==3
%         [a, Qmax]=maxQ(state,reshape(SOM(:,win_ind),length(feats),p.A),p);
%     end
% %     if mem_ind==1
% %         [a, Qmax]=maxQ(state,w,p);        
% %     elseif mem_ind==2
% %         [a, Qmax]=maxQ(state,reshape(SOM(:,win_ind),length(feats),p.A),p);
% %     end
    if rand>=p.epsilon
        [a, Qmax]=maxQ(state,w,p);        
    else
%         a=randi(p.A);
        [a, Qmax]=maxQ(state,reshape(SOM(:,win_ind),length(feats),p.A),p);%take action suggestion from winner SOM
        SOMadvice=[SOMadvice; max(d)];%log the index of the winning SOM
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    next_state=transition(state,a,p);    
    if norm(next_state(1:2)-goal)<=p.target_thresh
        R=p.highreward;
    elseif p.world(round(next_state(1)),round(next_state(2)))==1
        R=p.penalty;
    else R=p.livingpenalty;
    end
    Q_s_a=Q_val(state,a,w,p);
    err=R-Q_s_a;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [feats]=featsfromstate(state,p);
    ef=e(:,a);
    ef(feats==1)=1;
    if R==p.highreward
        w(:,a)=w(:,a)+p.alpha*err*ef; 
        break
    else    
        [a_next, Qmax_next]=maxQ(next_state,w,p);
        err=err+p.gamma*Qmax_next;
        w(:,a)=w(:,a)+p.alpha*err*ef;
        e(:,a)=ef;
        e=p.lambda*p.gamma*e;
    end
    
    state=next_state;
    count=count+1;
    if count>10000
        disp('Broke!')
        break
    end
    
    end
    
end
