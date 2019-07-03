function [w,clusters,wi]=Q_learn_clustering(SOM,p,goal,clusters,w)
state=p.start;
[feats]=featsfromstate(state,p);%get features from state
e=zeros(length(feats),p.A);%eligibility trace
reward_feats=feats(1:p.reward_inds);%reward features
reward_feats(goal==0)=0;
count=1;
w=reshape(w,length(feats)*p.A,1);%reshape into a column vector
s_som=size(SOM);
wi=[];
for j=1:s_som(2)
    d(j)=w'*SOM(:,j)/norm(SOM(:,j))/norm(w);%go through all the SOMs and calculate cosine similarity b/w w and SOMs
end
win_ind=find(d==max(d));%most similar SOM index
if length(win_ind)>1
    win_ind=win_ind(randi(length(win_ind)));
end
beta=max(d);
% fbeta=1/(1+exp(-p.squashparam*(beta-p.transfer_thresh)));%fbeta is >0.5 only if beta is more than the threshold
% w=w*(1-fbeta)+fbeta*(SOM(:,win_ind));  
w=reshape(w,length(feats),p.A); 
    while sum(goal==reward_feats)<p.reward_inds%norm(state(1:2)-goal)>p.target_thresh     
% % % %         other possible ways of exploring based on probs
% % %         probs=[0.1 0.7 fbeta*exp(-i*exp_const)];%/sqrt(sqrt(sqrt(i)))];%/sqrt(i)];%random,greedy,SOMbased 
% % %         probs=[0.7 0.3];%/sqrt(sqrt(sqrt(i)))];%/sqrt(i)];%random,greedy,SOMbased
% % %         [mem_ind,b]=selectsample(probs,mem_ind,b);%probability proportional selection
        
        if rand<p.epsilon
            [a, Qmax]=maxQ(state,reshape(SOM(:,win_ind),length(feats),p.A),p);%take action suggestion from winner SOM (SOM guided exploration)
            wi=[wi;win_ind];
%             a=randi(p.A);
            opt_act=0;
        else [a, Qmax]=maxQ(state,w,p);      
            opt_act=1;
        end  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    next_state=transition(state,a,p);
    [feats_next]=featsfromstate(next_state,p);
    reward_feats=feats_next(1:p.reward_inds);
    reward_feats(goal==0)=0;
%     Rewards%
    if sum(goal==reward_feats)==p.reward_inds%norm(next_state(1:2)-goal)<=p.target_thresh
        R=p.highreward;
    elseif p.world(round(next_state(1)),round(next_state(2)))==1
        R=p.penalty;
    else R=p.livingpenalty;
    end
    
    Q_s_a=Q_val(state,a,w,p);%Q value
    err=R-Q_s_a;%TD error
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [feats]=featsfromstate(state,p);
    ef=e(:,a);%eligibility trace
    ef(feats==1)=1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if R==p.highreward
        w(:,a)=w(:,a)+p.alpha*err*ef; %update weights - Q-lambda algorithm
        break
    else    
        [a_next, Qmax_next]=maxQ(next_state,w,p);
        err=err+p.gamma*Qmax_next;
        w(:,a)=w(:,a)+p.alpha*err*ef;
        e(:,a)=ef;
        e=p.lambda*p.gamma*e;%trace update
    end
    
    [clusters]=k_means(feats(1:p.reward_inds),clusters,p);%adaptive clustering
    state=next_state;

    count=count+1;
    if count>10000%max number of agent-env interactions
        disp('Broke!')
        break
    end
    
    end