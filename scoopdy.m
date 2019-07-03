%this function assigns tags to each reward feature vector and matches the
%return logs to it
function [returnscoop]=scoopdy(clusters_all, returns_all, p)
s=length(clusters_all{1});
for i=1:s
returnscoop{i}=[];
end
%assign tags
for i=1:length(clusters_all)
    for j=1:length(clusters_all{i})
        if sum(round(clusters_all{i}{j}(:,1))==[0;0;0;0])==p.reward_inds
            tag=1;
        elseif sum(round(clusters_all{i}{j}(:,1))==[0;0;0;1])==p.reward_inds
            tag=2;
        elseif sum(round(clusters_all{i}{j}(:,1))==[0;0;1;0])==p.reward_inds
            tag=3;   
        elseif sum(round(clusters_all{i}{j}(:,1))==[0;1;0;0])==p.reward_inds
            tag=4;
        elseif sum(round(clusters_all{i}{j}(:,1))==[1;0;0;0])==p.reward_inds
            tag=5;
        elseif sum(round(clusters_all{i}{j}(:,1))==[1;0;0;1])==p.reward_inds
            tag=6;
        elseif sum(round(clusters_all{i}{j}(:,1))==[0;1;1;0])==p.reward_inds
            tag=7;
        end
        tag
        returnscoop{tag}=[returnscoop{tag} ;returns_all{i}{j}];%assign appropriate return log
    end
end