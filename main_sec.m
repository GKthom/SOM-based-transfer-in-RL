clear all
close all
clc

p=parameters();
state=p.start;
% initial_tasks=[2 2;2 28;28 28;28 2];
initial_tasks=ones(p.initialtasks,2)+(p.a-2)*rand(p.initialtasks,2);%[2 2;2 28;28 28;28 2];
s_it=size(initial_tasks);

%Sequentially learn the n tasks
for i=1:s_it(1)
[ww{i},avr]=Q_learn(p,initial_tasks(i,:));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SOM=[];
%%%%%%%Add tasks to SOM%%%%%%%%%%%%%%%%%%%
SOM=SOM_add(SOM,ww,p);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Introduce new tasks and select from SOM
% new_task=[25 28];
new_tasks=ones(p.initialtasks,2)+(p.a-2)*rand(p.initialtasks,2);%[2 2;2 28;28 28;28 2];
new_tasks(1,:)=[28 28];
%Learn new task using knowledge of previous tasks
avgretnewtasks={};
avgretnew=[];
for k=1:p.N_runs
    k
[w_new, avgret, wsec, avgretsec]=Q_learnfromSOM_sec(SOM,new_tasks,p);
avgretnew=[avgretnew avgret];
avgretnewtasks={avgretnewtasks avgretsec};
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plot(mean(avgretnew'))
load handel
sound(y,Fs)