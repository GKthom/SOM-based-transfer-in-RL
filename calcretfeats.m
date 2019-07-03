%computes returns by greedily exploiting the value function weights
function [retj]=calcretfeats(w,p,goal)


retj=0;
for j=1:100%run 100 times
state=[(rand*(p.a)) (rand*(p.b)) 0];%random starting state
%make sure state is valid
if state(1)<=1
    state(1)=1;
elseif state(1)>=p.a
    state(1)=p.a;
end

if state(2)<=1
    state(2)=1;
elseif state(2)>=p.b
    state(2)=p.b;
end

ret=0;%initialize return

for i=1:100%take 100 steps
    [a, Qmax]=maxQ(state,w,p);
    state=transition(state,a,p);
    [feats]=featsfromstate(state,p);
    reward_feats=feats(1:p.reward_inds);
    reward_feats(goal==0)=0;
    if sum(goal==reward_feats)==p.reward_inds%norm(state(1:2)-goal)<=p.target_thresh
        r=p.highreward;
    else r=p.livingpenalty;
    end
    ret=ret+r;%sum of rewards
end
retj=retj+ret;%accumulate returns over 100 runs
end
retj=retj/j;%average out the returns