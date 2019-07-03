function [w,avgret]=Q_learnfromSOMonly(SOM,goal,p)

feats=featsfromstate(p.start,p);
w=rand(length(feats),p.A);
avgret=[];

%%%%%%%Check which SOM is closest to these wts and learn from them with Q-learning%%%%%%
for i=1:p.N_iter
    i    
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
    if beta>0.9
    fbeta=1/(1+2.71^(-p.squashparam*(beta-p.transfer_thresh)));%check and see if dividing by sqrt(i) is necessary
    else fbeta=0;
    end
    w=w*(1-fbeta)+fbeta*(SOM(:,win_ind));  
    w=reshape(w,length(feats),p.A); 
    e=zeros(length(feats),p.A);
    avgret=[avgret;calcret(w,p,goal)];
    count=0;
    p=parameters();
    state=p.start;
    while norm(state(1:2)-goal)>p.target_thresh
        if rand<p.epsilon
            a=randi(p.A);
            opt_act=0;
        else [a, Qmax]=maxQ(state,w,p);      
            opt_act=1;
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
