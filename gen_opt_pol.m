function [policy]=gen_opt_pol(w,p,goal)
p=parameters();
state=p.start;
% state=[7 8 0];
policy=[];
figure
axis([0 30 0 30])
hold on
count=0;
for i=1:p.a
    for j=1:p.b
        if p.world(i,j)==1
        scatter(i,j,'k','filled');
        hold on
        end
    end
end
scatter(p.target(1),p.target(2),'r');
scatter(p.target2(1),p.target2(2),'b');

while abs(state(1)-goal(1))>3||abs(state(2)-goal(2))>3
    if count>1
        if rand>0.9
            a=randi(p.A);
        else [a, Qmax]=maxQ(state,w,p);
        end
    else
        [a, Qmax]=maxQ(state,w,p);
    end
    policy=[policy;a];
    scatter(state(1),state(2),'k','filled');
    pause(0.001)
    hold on
    state=transition(state,a,p)
    count=count+1;
end

    if count>100
        disp('epsilon-greedy policy')
    else disp('Optimal policy')
    end