clear all
close all
clc

p=parameters();
state=p.start;
% initial_tasks=[2 2;2 28;28 28;28 2];
initial_tasks=ones(p.initialtasks,2)+(p.a-2)*rand(p.initialtasks,2);%[2 2;2 28;28 28;28 2];
s_it=size(initial_tasks);
% % % %initial goal training
% % % avgretlog=[];
% % % for kkk=1:1
% % % [w,avgret]=Q_learn(p,[2 25]);
% % % avgretlog=[avgretlog;avgret];
% % % end
%Sequentially learn the n tasks
for i=1:s_it(1)
[ww{i},avr]=Q_learn(p,initial_tasks(i,:));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% save initial_tasks initial_tasks
% save ww ww
% pause
SOM=[];
%%%%%%%Add tasks to SOM%%%%%%%%%%%%%%%%%%%
SOM=GSOM_add(SOM,ww,p);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% s_som=size(SOM);
% for i=1:s_som(2)
%     for j=1:length(ww)
%         d(i,j)=norm(SOM(:,i)-reshape(ww{j},200*9,1));
%     end
%     D{i}=d;
% end

%Introduce new task and select from SOM
new_task=[25 28];
%Learn new task using knowledge of previous tasks
% % % avgretnewtasks=[];
% % % for k=1:p.N_runs
% % %     k
% % % [w_new, avgret]=Q_learnfromSOM(SOM,new_task,p);
% % % avgretnewtasks=[avgretnewtasks avgret];
% % % end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % % avgretnewtasks=[];
% % % for k=1:p.N_runs
% % %     k
% % % [w_new, avgret]=Q_learnfromSOMonly(SOM,new_task,p);
% % % avgretnewtasks=[avgretnewtasks avgret];
% % % end
SOMadvice_log={};
avgretnewtasks=[];
for k=1:p.N_runs
    k
[w_new, avgret,SOMadvice]=Q_learnfromSOM_explore(SOM,new_task,p);
avgretnewtasks=[avgretnewtasks avgret];
SOMadvice_log{k}=SOMadvice;
end

% % % avgretnewtasks=[];
% % % for k=1:p.N_runs
% % %     k
% % % [w_new, avgret]=Q_learn_plain(SOM,new_task,p);
% % % avgretnewtasks=[avgretnewtasks avgret];
% % % end

plot(mean(avgretnewtasks'))
load handel
sound(y,Fs)
%%Let agent exlpore and identify objectives. After each objective is
%%identified, learn the weights corresponding to that task. After the
%%weight is learned, call SOM as shown below. Learn N=30 tasks like this.
%%Then learn the new task. using transfer from the SOM.
% % % for i=1:s_x(2)
% % %     i
% % %     s_SOM=size(SOM);
% % %     if i>1
% % %     for j=1:s_SOM(2)
% % %         newxx{j}=SOM(:,j);
% % %     end
% % %     ips=[newxx {x(:,i)}];
% % %     else ips={x(:,i)};
% % %     end
% % %     [SOM]=GSOM_add_new(SOM,ips,p);
% % % end
% % % [im_main]=plotSOM(SOM,20,16);