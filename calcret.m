function [retj]=calcret(w,p,goal)


retj=0;
for j=1:100
state=[(rand*(p.a)) (rand*(p.b)) 0];
% state=p.start;
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

i=1;
ret=0;

for i=1:100
    [a, Qmax]=maxQ(state,w,p);
    state=transition(state,a,p);
    if norm(state(1:2)-goal)<=p.target_thresh
        r=p.highreward;
    else r=p.livingpenalty;
    end
    ret=ret+r;
end
retj=retj+ret;
end
retj=retj/j;