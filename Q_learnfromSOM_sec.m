function [w,avgret,wsec,avgretsec]=Q_learnfromSOM_sec(SOM,goals,p)

feats=featsfromstate(p.start,p);
w=rand(length(feats),p.A);
avgret=[];

for i=1:length(goals)
    wsec{i}=rand(length(feats),p.A);
    avgretsec{i}=[];
end
goal=goals(1,:);

exp_const=log(p.min_SOM_update)/(p.initlearn-p.N_iter);

for i=1:(p.initlearn)
    breakflag=0;
    i
    e=zeros(length(feats),p.A);
    avgret=[avgret;calcret(w,p,goal)];
    count=0;
    p=parameters();
    state=p.start;
    while norm(state(1:2)-goal(1,:))>p.target_thresh
        if rand<p.epsilon
            a=randi(p.A);
        else [a, Qmax]=maxQ(state,w,p);      
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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if R==p.highreward
        w(:,a)=w(:,a)+p.alpha*err*ef; 
        breakflag=1;
    else    
        [a_next, Qmax_next]=maxQ(next_state,w,p);
        err=err+p.gamma*Qmax_next;
        w(:,a)=w(:,a)+p.alpha*err*ef;
    end
    
    
    %%%%%%%Secondary goals%%%%%%%%
    for j=2:length(goals)
        avgretsec{j}=[avgretsec{j};calcret(wsec{j},p,goals(j,:))];
        if norm(next_state(1:2)-goals(j,:))<=p.target_thresh
            R=p.highreward;
        elseif p.world(round(next_state(1)),round(next_state(2)))==1
            R=p.penalty;
        else R=p.livingpenalty;
        end    
    Q_s_a=Q_val(state,a,wsec{j},p);
    err=R-Q_s_a;    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if R==p.highreward
        wsec{j}(:,a)=wsec{j}(:,a)+p.alpha*err*ef; 
    else    
        [a_next, Qmax_next]=maxQ(next_state,wsec{j},p);
        err=err+p.gamma*Qmax_next;
        wsec{j}(:,a)=wsec{j}(:,a)+p.alpha*err*ef;        
    end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    e(:,a)=ef;
    e=p.lambda*p.gamma*e;
    state=next_state;
    count=count+1;
    if breakflag==1
        break
    end
    
    end
end

%%%%%%%Check which SOM is closest to these wts and learn from them with Q-learning%%%%%%
for i=1:(p.N_iter-p.initlearn)
    i    
    breakflag=0;
    w=reshape(w,length(feats)*p.A,1);
    s_som=size(SOM);
    for j=1:s_som(2)
        d(j)=w'*SOM(:,j)/norm(SOM(:,j))/norm(w);
    end
    win_ind=find(d==max(d));
    if length(win_ind)>1
        win_ind=win_ind(randi(length(win_ind)));
    end    
    beta=max(d);%/sqrt(i);
    fbeta=1/(1+2.71^(-p.squashparam*(beta-p.transfer_thresh)));%check and see if dividing by sqrt(i) is necessary
    if fbeta>0.8
        fbeta=fbeta*exp(-i*exp_const);
        w=w*(1-fbeta)+fbeta*(SOM(:,win_ind));  
    end
    w=reshape(w,length(feats),p.A); 
    e=zeros(length(feats),p.A);
    avgret=[avgret;calcret(w,p,goal)];
    
    
    %%%%%%%%%SOM update for secondary goals%%%%%%%
    for j=2:length(goals)
        wsec{j}=reshape(wsec{j},length(feats)*p.A,1);
        s_som=size(SOM);
        for k=1:s_som(2)
            d(k)=wsec{j}'*SOM(:,k)/norm(SOM(:,k))/norm(wsec{j});
        end
        win_ind=find(d==max(d));
        if length(win_ind)>1
            win_ind=win_ind(randi(length(win_ind)));
        end    
        beta=max(d);%/sqrt(i);
        fbeta=1/(1+2.71^(-p.squashparam*(beta-p.transfer_thresh)));
        if fbeta>0.8
            fbeta=fbeta*exp(-i*exp_const);
            wsec{j}=wsec{j}*(1-fbeta)+fbeta*(SOM(:,win_ind));  
        end
        wsec{j}=reshape(wsec{j},length(feats),p.A); 
        avgretsec{j}=[avgretsec{j};calcret(wsec{j},p,goals(j,:))];
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    count=0;
    p=parameters();
    state=p.start;
    
    
    
    
    while norm(state(1:2)-goal)>p.target_thresh
        if rand<p.epsilon
            a=randi(p.A);
        else [a, Qmax]=maxQ(state,w,p);      
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
        breakflag=1;
    else    
        [a_next, Qmax_next]=maxQ(next_state,w,p);
        err=err+p.gamma*Qmax_next;
        w(:,a)=w(:,a)+p.alpha*err*ef;
    end
    
    
    %%%%%%%Secondary goals%%%%%%%%
    for j=2:length(goals)
        avgretsec{j}=[avgretsec{j};calcret(wsec{j},p,goals(j,:))];
        if norm(next_state(1:2)-goals(j,:))<=p.target_thresh
            R=p.highreward;
        elseif p.world(round(next_state(1)),round(next_state(2)))==1
            R=p.penalty;
        else R=p.livingpenalty;
        end    
    Q_s_a=Q_val(state,a,wsec{j},p);
    err=R-Q_s_a;    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if R==p.highreward
        wsec{j}(:,a)=wsec{j}(:,a)+p.alpha*err*ef; 
        break
    else    
        [a_next, Qmax_next]=maxQ(next_state,wsec{j},p);
        err=err+p.gamma*Qmax_next;
        wsec{j}(:,a)=wsec{j}(:,a)+p.alpha*err*ef;        
    end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    e(:,a)=ef;
    e=p.lambda*p.gamma*e;
    state=next_state;
    count=count+1;
    if breakflag==1
%         disp('Broke!')
        break
    end
    
    end
    
end
