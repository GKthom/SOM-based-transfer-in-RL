function [im]=show_clusters(p,clusters)


s=size(p.world);

for i=1:s(1)

for j=1:s(2)

[S]=featsfromstate([i j rand*360],p);%([i j rand*360],world,light,rough,target_pos,tol,x,y);
sensor_reading=S(1:p.reward_inds);%S{cluster_select};
stats=clusters;
col=distinguishable_colors(length(stats));
d=[];
for k=1:length(stats)
d(k)=norm([sensor_reading]-[stats{k}(:,1)]);
c=argmin(d);
im(i,j,1:3)=col(c,:);
end

end

end
image(imrotate(im,90))