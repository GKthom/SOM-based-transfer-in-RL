function [im_main]=plotSOM(wSOM,x,y)

im_main=[];
s_SOM=size(wSOM);
cnt=1;
for j=1:sqrt(s_SOM(2))
    im_temp=[];
for i=1:sqrt(s_SOM(2))        
    im_temp=[im_temp;reshape(wSOM(:,cnt),x,y)];
    cnt=cnt+1;
end
im_main=[im_main im_temp];
end