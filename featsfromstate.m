function [final_feats]=featsfromstate(state,p)

final_feats_a=zeros(p.nfeats_a,1);
final_feats_b=zeros(p.nfeats_b,1);

% feats_a=round(p.nfeats_a*(state(1)-p.min_a)/(p.max_a-p.min_a));
% feats_b=round(p.nfeats_b*(state(2)-p.min_b)/(p.max_b-p.min_b));
feats_a=round(p.nfeats_a*(state(1))/(p.max_a));
feats_b=round(p.nfeats_b*(state(2))/(p.max_b));
% if feats_a>0&&feats_b>0
final_feats_a(feats_a)=1;
final_feats_b(feats_b)=1;
% end
pre_final_feats=[final_feats_a;final_feats_b];

%add env feature vector

efv=zeros(p.reward_inds,1);
if norm(state(1:2)-p.target)<=3
    efv(1)=1;
end

if norm(state(1:2)-p.target2)<=3
    efv(2)=1;
end

if norm(state(1:2)-p.target3)<=3
    efv(3)=1;
end

if norm(state(1:2)-p.target4)<=3
    efv(4)=1;
end

% addtargs=p.addtargs;
% for i=1:length(addtargs)
%     if norm(state(1:2)-addtargs(i,:))<=3
%         efv(4+i)=1;
%     end
% end

final_feats=[efv;pre_final_feats];