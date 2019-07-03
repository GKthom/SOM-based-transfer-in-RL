%GSOM sequential test
load SOM_eps1
SOM=[];
seq_no=6;
[SOM,SOMout]=GSOM_add_vid_seq(SOM,{ww{1}},ww,clusters,p,1);
for i=2:seq_no
s_SOM=size(SOM);
for j=1:s_SOM(2)
   newxx{j}=SOM(:,j);%SOM node weights
end
ips=[newxx ww{i}]; %use SOM nodes as inputs to the SOM for subsequent iterations
[SOM,SOMout]=GSOM_add_vid_seq(SOM,ips,ww,clusters,p,i);
end