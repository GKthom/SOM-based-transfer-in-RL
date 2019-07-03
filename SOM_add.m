function [SOM]=SOM_add(SOM,ww,p)

s_ww=size(ww{1});
for i=1:length(ww)
    x(:,i)=reshape(ww{i},s_ww(1)*s_ww(2),1);
end

s_x=size(x);
w=rand(s_x(1),p.N_SOM);

for n=1:p.SOM_iter

for i=1:s_x(2)  
    s_w=size(w);
    cos_sim=[];
    for t=1:s_w(2)
        cos_sim(t)=((x(:,i))'*(w(:,t)))/norm(x(:,i))/norm(w(:,t));%norm(x(:,i)-w(:,t));%sqrt(sum((x(:,i)-w(:,t)).^2));
    end
    maxsim=max(cos_sim);%%minimum of those distances taken
    a=find(cos_sim==maxsim);
    if length(a)>1
        a=a(randi(length(a)));
    end
    
%%%%%%%%%%index of winner neuron%%%%%%%%%
Neu=1:p.N_SOM; %%%%dummy matrix 
d=reshape(Neu,sqrt(p.N_SOM),sqrt(p.N_SOM));%%dummy 
[r c]=find(d);
rw=r(a);% row index of winner
cw=c(a);% column index of winner


%%update weights%%%%%%%%%%
for j=1:p.N_SOM
    rl=r(j);%row index of 'loser' neurons
    cl=c(j);%column index of 'loser' neurons
    dji=sqrt((rw-rl)^2+(cw-cl)^2); %distance between the winner and the current neuron   
    Zo=50; %%%%sigma0
    tau1=1000/log(Zo);
    etao=0.1;
    eta=etao*exp(-(n-1)/1000);
    Z=Zo*exp(-(n-1)/tau1);%sigma
    hji=exp(-(dji^2)/(2*(Z^2)));
    w(:,j)=w(:,j)+eta*hji*((x(:,i))-(w(:,j)));
end  

end
n
end

SOM=w;