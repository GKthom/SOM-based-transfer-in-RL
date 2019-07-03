function [a, Qmax]=maxQ(state,w,p)

s=size(w);

for i=1:p.A
    q(i)=Q_val(state,i,w,p);
end

a=argmax(q);
Qmax=q(a);