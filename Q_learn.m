function [w,avgret]=Q_learn(p,goal)

feats=featsfromstate(p.start,p);
w=rand(length(feats),p.A);
avgret=[];
for i=1:p.N_iter
    if i/p.N_iter==0.5
        disp('50%')
    elseif i/p.N_iter==0.75
        disp('75%')
    elseif i==p.N_iter
        disp('100%')
    end
    e=zeros(length(feats),p.A);
%     avgret(i)=calcret(w,p,goal);
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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

% w=w/max(max(w));