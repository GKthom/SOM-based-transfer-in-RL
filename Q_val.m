function [Q]=Q_val(state,action,w,p)

% % % [S]=sense_world(state,p);
[feats]=featsfromstate(state,p);
Q=w(:,action)'*feats;