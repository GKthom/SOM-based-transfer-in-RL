function [new_state]=transition(state,action,p)

dt=0.2;
v=6;

if action==1%Move up
    new_state(2)=state(2)+v*dt;
    new_state(1)=state(1);
    new_state(3)=90;
elseif action==2%Move right
    new_state(1)=state(1)+v*dt;
    new_state(2)=state(2);
    new_state(3)=0;
elseif action==3%Move down
    new_state(2)=state(2)-v*dt;
    new_state(1)=state(1);
    new_state(3)=-90;
elseif action==4%Move left
    new_state(1)=state(1)-v*dt;
    new_state(2)=state(2);
    new_state(3)=180;
elseif action==5%Move diagonally right and up
    new_state(1)=state(1)+v*dt;
    new_state(2)=state(2)+v*dt;
    new_state(3)=45;
elseif action==6%Move diagonally left and up
    new_state(1)=state(1)-v*dt;
    new_state(2)=state(2)+v*dt;
    new_state(3)=135;
elseif action==7%Move diagonally right and down
    new_state(1)=state(1)+v*dt;
    new_state(2)=state(2)-v*dt;
    new_state(3)=-45;
elseif action==8%Move diagonally left and down
    new_state(1)=state(1)-v*dt;
    new_state(2)=state(2)-v*dt;
    new_state(3)=-135;
elseif action==9%Stay put
    new_state(1)=state(1);
    new_state(2)=state(2);
    new_state(3)=state(3);
end

if abs(new_state(1))>=p.max_a||(new_state(1))<p.min_a||abs(new_state(2))>=p.max_b||(new_state(2))<p.min_b
    new_state=state;
end